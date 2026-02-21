import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsign;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/core/services/storage_service.dart';

class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({required this.apiClient});
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn.instance;


  // Future<String> getDeviceId() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //
  //   if (Platform.isAndroid) {
  //     final androidInfo = await deviceInfo.androidInfo;
  //     return androidInfo.id; // অথবা androidInfo.device, androidInfo.model
  //   } else if (Platform.isIOS) {
  //     final iosInfo = await deviceInfo.iosInfo;
  //     return iosInfo.identifierForVendor ?? "unknown";
  //   } else {
  //     return "unsupported";
  //   }
  // }

  /// ===================== SIGNUP =====================
  Future<Response> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String country,
  }) async {
    return await apiClient.postData(ApiConstants.signup, {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "country": country,
    });
  }

  /// ===================== LOGIN =====================
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await apiClient.postData(ApiConstants.login, {
      "email": email,
      "password": password,
    });
  }

  /// ===================== FORGOT PASSWORD =====================
  Future<Response> forgotPassword({required String email}) async {
    return await apiClient.postData(ApiConstants.forgotPassword, {
      "email": email,
    });
  }

  /// ===================== RESEND OTP =====================
  Future<Response> resentOtp({required String email}) async {
    return await apiClient.postData(ApiConstants.resendVerifyEmail, {
      "email": email,
    });
  }

  /// ===================== OTP VERIFY =====================
  Future<Response> otpVerify({
    required String email,
    required int oneTimeCode,
  }) async {
    return await apiClient.postData(ApiConstants.verifyEmail, {
      "email": email,
      "oneTimeCode": oneTimeCode,
    });
  }

  /// ===================== RESET PASSWORD =====================
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await apiClient.postData(ApiConstants.resetPassword, {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    }, resetToken: token);
  }

  /// ===================== LOGOUT =====================
  Future<Response> logout(String deviceToken) async {
    return await apiClient.postData(ApiConstants.logout, {
      "deviceToken": deviceToken,
    });
  }

  /// ===================== REFRESH TOKEN =====================
  Future<Response> refreshToken(String refreshToken) async {
    return await apiClient.postData(ApiConstants.refreshToken, {
      "refreshToken": refreshToken,
    });
  }

  /// ===================== CHANGE PASSWORD =====================
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await apiClient.postData(ApiConstants.resetPassword, {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    });
  }

  final gsign.GoogleSignIn _googleSignIn = gsign.GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final List<String> scopes = ['email', 'profile'];

  // ─── Google Sign-In ───────────────────────────────────────────
  Future<Map<String, dynamic>> signInWithGoogle() async {
    await googleSignIn.initialize();
    try {
     final  googleUser =await googleSignIn.authenticate();
     final googleAuth = await googleUser.authorizationClient.authorizationForScopes(scopes);
     final accessToken = googleAuth?.accessToken;
     final idToken = googleAuth?.;
     final email = googleUser.email;
     final name = googleUser.displayName;
     final photo = googleUser.photoUrl;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign-In বাতিল হয়েছে');

      final gsign.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final response = await apiClient.postData(ApiConstants.googleSignIn, {
        'id_token': googleAuth.idToken,
        'access_token': googleAuth.accessToken,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'photo': googleUser.photoUrl,
      });

      // Token save করো
      await _saveAuthResponse(response);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Apple Sign-In ────────────────────────────────────────────
  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? fullName =
          '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();

      final response = await apiClient.postData(
        '/auth/apple', // তোমার endpoint
        {
          'identity_token': credential.identityToken,
          'authorization_code': credential.authorizationCode,
          'email': credential.email,
          'name': fullName?.isEmpty == true ? null : fullName,
          'user_id': credential.userIdentifier,
        },
      );

      await _saveAuthResponse(response);
      return response.data;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Apple Sign-In বাতিল হয়েছে');
      }
      throw Exception('Apple Sign-In error: ${e.message}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Error Handler ────────────────────────────────────────────
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('সংযোগ সমস্যা, আবার চেষ্টা করুন');
      case DioExceptionType.badResponse:
        final message = e.response?.data['message'] ?? 'কিছু একটা ভুল হয়েছে';
        return Exception(message);
      default:
        return Exception('ইন্টারনেট সংযোগ চেক করুন');
    }
  }

  /// Handles saving tokens from Response
  Future<void> _saveAuthResponse(Response response) async {
    final data = response.data;
    final authData = data['data'] ?? data;

    final String? accessToken = authData['accessToken'] ?? authData['token'];
    final String? refreshToken = authData['refreshToken'];

    if (accessToken != null) {
      await StorageService.setString(StorageConstants.bearerToken, accessToken);
    }

    if (refreshToken != null) {
      await StorageService.setString(
        StorageConstants.refreshToken,
        refreshToken,
      );
    }
  }
}

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({required this.apiClient});
  Future<FirebaseAuth> get auth async {
    return FirebaseAuth.instance;
  }
  
  final googleSignIn = GoogleSignIn.instance;
  //  final GoogleSignIn googleSignIn = GoogleSignIn();

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
  Future<Response> resendOtp({required String email}) async {
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

  // final gsign.GoogleSignIn _googleSignIn = gsign.GoogleSignIn(
  //   scopes: ['email', 'profile'],
  // );
  final List<String> scopes = ['email', 'profile'];

  // ─── Google Sign-In ───────────────────────────────────────────

  Future<Response> signInWithGoogle() async {
    await googleSignIn.initialize();

    final googleUser = await googleSignIn.authenticate();
    // final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google Sign-In বাতিল হয়েছে');

    final googleAuth = googleUser.authentication;

    return await apiClient.postData(ApiConstants.googleSignIn, {
      'id_token': googleAuth.idToken,
      'email': googleUser.email,
      'name': googleUser.displayName,
      'photo': googleUser.photoUrl,
    });
  }

  // ─── Apple Sign-In ────────────────────────────────────────────
  Future<Response> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final String? fullName =
        '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();

    return await apiClient.postData(ApiConstants.appleSignIn, {
      'identity_token': credential.identityToken,
      'authorization_code': credential.authorizationCode,
      'email': credential.email,
      'name': fullName?.isEmpty == true ? null : fullName,
      'user_id': credential.userIdentifier,
    });
  }
}

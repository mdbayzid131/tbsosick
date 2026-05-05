import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({required this.apiClient});
  Future<FirebaseAuth> get auth async {
    return FirebaseAuth.instance;
  }

  // final googleSignIn = GoogleSignIn.instance;
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
    required String otp,
  }) async {
    return await apiClient.postData(ApiConstants.verifyEmail, {
      "email": email,
      "otp": otp,
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
    });
  }

  /// ===================== SOCIAL LOGIN =====================
  Future<Response> socialLogin({
    required String provider,
    required String idToken,
    String? nonce,
    String? deviceToken,
    required String platform,
  }) async {
    final Map<String, dynamic> body = {
      "provider": provider,
      "idToken": idToken,
      "platform": platform,
    };
    if (nonce != null) body["nonce"] = nonce;
    if (deviceToken != null) body["deviceToken"] = deviceToken;

    return await apiClient.postData(ApiConstants.socialLogin, body);
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
}

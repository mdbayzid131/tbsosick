import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/core/utils/nonce_helper.dart' hide generateNonce;
import 'package:tbsosick/data/repositories/auth_repository.dart';

class AuthService extends GetxService {
  late AuthRepo _authRepo;

  // Reactive state
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Explicitly find ApiClient to ensure it's initialized before AuthRepo
    _authRepo = AuthRepo(apiClient: Get.put(ApiClient()));

    // Check initial login state
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);
    isLoggedIn.value = token.isNotEmpty;
  }

  Future<AuthService> init() async {
    return this;
  }

  /// ===================== SIGNUP =====================
  Future<Response> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String country,
  }) async {
    try {
      final response = await _authRepo.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        country: country,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== LOGIN =====================
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authRepo.login(email: email, password: password);
      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== LOGOUT =====================
  Future<void> logout() async {
    try {
      // final response = await _authRepo.logout(deviceToken);
      await _clearLocalAuth();
      // return response;
    } catch (e) {
      await _clearLocalAuth();
      rethrow;
    }
  }

  /// ===================== FORGOT PASSWORD =====================
  Future<Response> forgotPassword(String email) async {
    try {
      final response = await _authRepo.forgotPassword(email: email);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== SOCIAL LOGIN (GOOGLE) =====================
  Future<Response?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS
            ? '344458357764-l2q9u3m6an945rg6vnga1op45mhce06o.apps.googleusercontent.com'
            : null,
        serverClientId:
            '344458357764-p7cinp8ik2ogrut9g54um2nqnn0nqg9g.apps.googleusercontent.com',
      );

      final account = await googleSignIn.signIn();
      if (account == null) return null; // user cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) return null;

      final fcmToken = await FirebaseMessaging.instance.getToken();
      final response = await _authRepo.socialLogin(
        provider: 'google',
        idToken: idToken,
        deviceToken: fcmToken,
        platform: Platform.isIOS ? 'ios' : 'android',
      );

      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== SOCIAL LOGIN (APPLE) =====================
  Future<Response?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final hashedNonce = sha256OfString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
        webAuthenticationOptions: Platform.isAndroid
            ? WebAuthenticationOptions(
                clientId: 'com.tbsosick.smrtscrub.service',
                redirectUri: Uri.parse(
                    'https://www.smrtscrub.com/api/v1/auth/apple/callback'),
              )
            : null,
      );

      final idToken = credential.identityToken;
      if (idToken == null) return null;

      final fcmToken = await FirebaseMessaging.instance.getToken();
      final response = await _authRepo.socialLogin(
        provider: 'apple',
        idToken: idToken,
        nonce: rawNonce,
        deviceToken: fcmToken,
        platform: Platform.isIOS ? 'ios' : 'android',
      );

      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== OTP VERIFY =====================
  Future<Response> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _authRepo.otpVerify(
        email: email,
        otp: otp,
      );
      if (response.statusCode == 200) {
        await _handleAuthResponse(response);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== RESEND OTP =====================
  Future<Response> resendOtp(String email) async {
    try {
      return await _authRepo.resendOtp(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== RESET PASSWORD =====================
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _authRepo.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== CHANGE PASSWORD =====================
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _authRepo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== HELPER METHODS =====================

  /// Handles successful auth response (Login/Signup)
  Future<void> _handleAuthResponse(Response response) async {
    // Adjust these keys based on your actual API response structure
    // Example: { "data": { "accessToken": "...", "refreshToken": "..." } }
    final data = response.data;
    if (data is! Map) return;

    // Check if data is nested
    final authData = data['data'] is Map ? data['data'] : data;

    final String? accessToken = authData['accessToken'] ?? authData['token'];
    final String? refreshToken = authData['refreshToken'];

    if (accessToken != null) {
      await StorageService.setString(StorageConstants.bearerToken, accessToken);
      isLoggedIn.value = true;
    }

    if (refreshToken != null) {
      await StorageService.setString(
        StorageConstants.refreshToken,
        refreshToken,
      );
    }

    final bool? isOnboardingCompleted = authData['isOnboardingCompleted'];
    if (isOnboardingCompleted != null) {
      await StorageService.setBool(
        StorageConstants.quickSetupCompleted,
        isOnboardingCompleted,
      );
    }
  }

  /// Clears all local auth data
  Future<void> _clearLocalAuth() async {
    await StorageService.remove(StorageConstants.bearerToken);
    await StorageService.remove(StorageConstants.refreshToken);
    await StorageService.remove(StorageConstants.userData);

    isLoggedIn.value = false;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => isLoggedIn.value;
}

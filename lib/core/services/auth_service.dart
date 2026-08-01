import 'package:get/get.dart' hide Response;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/repositories/auth_repository.dart';

class AuthService extends GetxService {
  late AuthRepo _authRepo;

  // Reactive state
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Find the already-registered ApiClient from InitialBinding
    _authRepo = AuthRepo(apiClient: Get.find<ApiClient>());

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
      String? deviceToken;
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        Helpers.error('Failed to get FCM token: $e');
      }

      final response = await _authRepo.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );
      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== SYNC DEVICE TOKEN =====================
  Future<void> syncDeviceToken(String token) async {
    try {
      await _authRepo.syncDeviceToken(token);
      Helpers.info('🔄 Device token synced with backend');
    } catch (e) {
      Helpers.error('❌ Failed to sync device token: $e');
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // user cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to retrieve Firebase ID Token.');
      }

      final response = await _authRepo.socialLogin(
        provider: 'google',
        idToken: idToken,
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
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithProvider(AppleAuthProvider());

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to retrieve Firebase ID Token.');
      }

      final response = await _authRepo.socialLogin(
        provider: 'apple',
        idToken: idToken,
      );

      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== OTP VERIFY =====================
  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _authRepo.otpVerify(email: email, otp: otp);
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
  }) async {
    try {
      final response = await _authRepo.resetPassword(
        token: token,
        newPassword: newPassword,
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

    final dynamic rawUserId = authData['user']?['id'] ??
        authData['user']?['_id'] ??
        authData['userId'] ??
        authData['id'];
    if (rawUserId != null) {
      await saveUserId(rawUserId.toString());
    }

    final bool? isOnboardingCompleted = authData['isOnboardingCompleted'];
    if (isOnboardingCompleted != null) {
      await StorageService.setBool(
        StorageConstants.quickSetupCompleted,
        isOnboardingCompleted,
      );
    }
  }

  /// Manually save user ID (Useful when profile is fetched separately)
  Future<void> saveUserId(String id) async {
    Helpers.debug('IAP: Manually saving User ID: $id');
    await StorageService.setString(StorageConstants.userId, id);
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

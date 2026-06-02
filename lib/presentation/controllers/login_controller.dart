import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';






import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = RxnString();
  final passwordError = RxnString(); 

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    emailError.value = null;
    passwordError.value = null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    emailError.value = Validators.email(emailController.text);
    passwordError.value = Validators.password(passwordController.text);

    if (emailError.value != null || passwordError.value != null) return;

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      Response response = await _authService.login(
        email: email,
        password: password,
      );

      ApiChecker.checkWriteApi(response);

      if (response.statusCode == 200) {
        Helpers.showSuccess('Login successful');

        final data = response.data;
        final authData = data['data'] is Map ? data['data'] : data;
        final bool isOnboardingCompleted =
            authData['isOnboardingCompleted'] ?? true;

        if (!isOnboardingCompleted) {
          Get.offAllNamed(AppRoutes.welcomePage);
        } else {
          Get.offAllNamed(AppRoutes.bottomNavBar);
        }
      } else if ((response.data is Map &&
          response.data['message'] != null &&
          response.data['message'].toString().contains(
            'Please verify your account',
          ))) {
        // If unverified, resend OTP and go to verification screen
        await _authService.resendOtp(email);
        Get.toNamed(AppRoutes.otpVerification, arguments: email);
      }
    } catch (e) {
      Helpers.error("login error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    clearControllers();
    Get.toNamed(AppRoutes.register);      
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.logout();
      // ApiChecker.checkApi(response);
      // print('==================================================');
      // print(response.data);
      // print(response.statusCode);
      // print('==================================================');
      // if (response.statusCode == 200) {
      Helpers.showSuccess('Logout successful');
      clearControllers();
      Get.offAllNamed(AppRoutes.login);
      // }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final response = await _authService.signInWithGoogle();
      if (response?.statusCode == 200) {
        final data = response?.data;
        final authData = data['data'] is Map ? data['data'] : data;
        final bool isOnboardingCompleted =
            authData['isOnboardingCompleted'] ?? true;
        if (!isOnboardingCompleted) {
          Get.offAllNamed(AppRoutes.welcomePage);
        } else {
          Get.offAllNamed(AppRoutes.bottomNavBar);
        }
      } else {
        Helpers.showError(response?.data['message']);
      }
    } catch (e) {
      Helpers.showError(e.toString());
      Helpers.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      final response = await _authService.signInWithApple();
      if (response?.statusCode == 200) {
        final data = response?.data;
        final authData = data['data'] is Map ? data['data'] : data;
        final bool isOnboardingCompleted =
            authData['isOnboardingCompleted'] ?? true;
        if (!isOnboardingCompleted) {
          Get.offAllNamed(AppRoutes.welcomePage);
        } else {
          Get.offAllNamed(AppRoutes.bottomNavBar);
        }
      } else {
        Helpers.showError(response?.data['message']);
      }
    } catch (e) {
      Helpers.showError(e.toString());
      Helpers.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

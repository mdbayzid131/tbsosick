import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/splash_screen/controller/splash_controller.dart';

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
        final bool isOnboardingCompleted = authData['isOnboardingCompleted'] ?? true;

        if (!isOnboardingCompleted) {
          Get.offAllNamed(AppRoutes.WELCOME_PAGE);
        } else {
          Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
        }
      } else if ((response.data is Map &&
          response.data['message'] != null &&
          response.data['message'].toString().contains(
            'Please verify your account',
          ))) {
        // If unverified, resend OTP and go to verification screen
        await _authService.resendOtp(email);
        Get.toNamed(AppRoutes.OTP_VERIFICATION, arguments: email);
      } else {
        Helpers.showError(response.data['message']);
      }
    } catch (e) {
      Helpers.error("login error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
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
      Get.offAllNamed(AppRoutes.LOGIN);
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
     if(response?.statusCode == 200){ 
      final data = response?.data;
      final authData = data['data'] is Map ? data['data'] : data;
      final bool isOnboardingCompleted = authData['isOnboardingCompleted'] ?? true;
      if(!isOnboardingCompleted){
        Get.offAllNamed(AppRoutes.WELCOME_PAGE);
      }else{
        Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
      }
    }else{
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
      if(response?.statusCode == 200){
        final data = response?.data;
        final authData = data['data'] is Map ? data['data'] : data;
        final bool isOnboardingCompleted = authData['isOnboardingCompleted'] ?? true;
        if(!isOnboardingCompleted){
          Get.offAllNamed(AppRoutes.WELCOME_PAGE);
        }else{
          Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
        }
      }else{
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

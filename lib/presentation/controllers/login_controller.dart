// ignore: implementation_imports
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:tbsosick/config/constants/app_constants.dart';
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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    emailError.value = Validators.email(emailController.text);
    passwordError.value = Validators.password(passwordController.text);

    if (emailError.value != null || passwordError.value != null) return;

    try {
      isLoading.value = true;

      Response response = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      // ApiChecker response validate
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        Helpers.showSuccessSnackbar('Login successful');
        Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
      }
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
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
        Helpers.showSuccessSnackbar('Logout successful');
        Get.offAllNamed(AppRoutes.LOGIN);
      // }
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
   
    
  }
}

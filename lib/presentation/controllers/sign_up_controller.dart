import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';

class SignUpController extends GetxController {
  final AuthService _authService = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.onClose();
  }

  Future<void> signUp() async {
    if (isLoading.value) return;

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      isLoading.value = true;

      await _authService.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim().isEmpty
            ? "0000000000"
            : phoneController.text.trim(),
        country: countryController.text.trim().isEmpty
            ? "USA"
            : countryController.text.trim(),
      );

      Helpers.showSuccessSnackbar('Account created successfully');

      // Navigate to welcome page or verify email
      Get.offNamed(AppRoutes.WELCOME_PAGE);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

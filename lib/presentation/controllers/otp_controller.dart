
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';

class OtpController extends GetxController {
  final AuthService _authService = Get.find();
  
  final otpController = TextEditingController();
  final otpError = RxnString();
  final isLoading = false.obs;
  
  String email = "";

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? "";
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  Future<void> verifyOtp() async {
    otpError.value = Validators.otp(otpController.text.trim(), length: 6);
    if (otpError.value != null) return;

    try {
      isLoading.value = true;
      final Response<dynamic> response = await _authService.verifyOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      ApiChecker.checkWriteApi(response);

      if (response.statusCode == 200) {
        Helpers.showSuccess('Email verified successfully');
        Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      final response = await _authService.resendOtp(email);
      ApiChecker.checkWriteApi(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess('OTP sent successfully');
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

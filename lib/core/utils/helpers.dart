import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  // Format time from seconds to mm:ss
  static String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
    // 00:00
  }

  // Show snackbar
  static void showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Show success snackbar
  static void showSuccessSnackbar(String message) {
    showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(String message) {
    showSnackbar(title: 'Error', message: message, backgroundColor: Colors.red);
  }

  // Show loading dialog
  static void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

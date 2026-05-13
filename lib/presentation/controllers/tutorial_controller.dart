import 'package:flutter/material.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';


class TutorialController extends GetxController {
  final pageController = PageController();
  final currentStep = 0.obs;

  final isLoading = false.obs;
  final UserDataRepository _userRepo = Get.put(UserDataRepository());

  void next() {
    if (currentStep.value < 3) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> skip() async {
    await _completeOnboarding();
  }

  Future<void> finalizeSetup() async {
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    try {
      isLoading.value = true;
      // Hit the API
      await _userRepo.completeOnboarding();
      
      // Update local storage
      StorageService.setBool(StorageConstants.quickSetupCompleted, true);
      
      // Navigate to bottom nav bar
      Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
    } catch (e) {
      // Handle error if needed, but still allow navigation or show error
      Helpers.error("Error completing onboarding: $e");
      StorageService.setBool(StorageConstants.quickSetupCompleted, true);
      Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
    } finally {
      isLoading.value = false;
    }
  }
}

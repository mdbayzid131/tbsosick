import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/config/routes/app_pages.dart';


class TutorialController extends GetxController {
  final pageController = PageController();
  final currentStep = 0.obs;

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

  void skip() {
    Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
  }
}

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/config/constants/app_constants.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class OnboardingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _decideNextPage();
  }

  void _decideNextPage() async {
    final bool onboardingSeen =
        await StorageService.getBool(StorageConstants.onboardingSeen) ?? false;

    final token = await StorageService.getString(StorageConstants.bearerToken);

    // 🔹 Onboarding already seen
    if (onboardingSeen) {
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    }
    // 🔹 onboardingSeen == false হলে
    // Onboarding screen থাকবে (কিছুই করার দরকার নাই)
  }





Future<String> getOrCreateDeviceToken() async {
  String token = await StorageService.getString(StorageConstants.deviceToken);
  AppConstants.deviceToken = token;

  if (token.isEmpty) {
    token = const Uuid().v4(); // unique device token
    await StorageService.setString(
      StorageConstants.deviceToken,
      token,
    );
  }

  return token;
}

}

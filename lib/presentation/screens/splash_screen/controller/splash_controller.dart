import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3));
    _decideNextPage();
  }

  void _decideNextPage() async {
    final bool onboardingSeen =
        await StorageService.getBool(StorageConstants.onboardingSeen) ?? false;

    final token = await StorageService.getString(StorageConstants.bearerToken);

    if (!onboardingSeen) {
      Get.offAllNamed(AppRoutes.ONBOARDING);
      return;
    }

    if (token.isEmpty) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }

    final bool quickSetupCompleted = 
        await StorageService.getBool(StorageConstants.quickSetupCompleted) ?? false;

    if (quickSetupCompleted) {
      Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
    } else {
      Get.offAllNamed(AppRoutes.WELCOME_PAGE);
    }
  }
}





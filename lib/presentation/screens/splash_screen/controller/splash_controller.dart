import 'package:get/get.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';

class SplashController extends GetxController {
  final RxString appVersion = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    await Future.delayed(const Duration(seconds: 2));
    _decideNextPage();
  }

  void _decideNextPage() async {
    final bool onboardingSeen =
        await StorageService.getBool(StorageConstants.onboardingSeen) ?? false;

    final token = await StorageService.getString(StorageConstants.bearerToken);

    if (!onboardingSeen) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    if (token.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final bool quickSetupCompleted =
        await StorageService.getBool(StorageConstants.quickSetupCompleted) ??
        false;

    if (quickSetupCompleted) {
      Get.offAllNamed(AppRoutes.bottomNavBar);
    } else {
      Get.offAllNamed(AppRoutes.welcomePage);
    }
  }
}

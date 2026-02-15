import 'package:get/get.dart';
import 'package:tbsosick/core/controllers/internet_controller.dart';
import 'package:tbsosick/core/services/connectivity_service.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';
import 'package:tbsosick/presentation/controllers/auth_controller.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/presentation/controllers/forgate_password.dart';
import 'package:tbsosick/presentation/controllers/login_controller.dart';
import 'package:tbsosick/presentation/controllers/reset_password.dart';
import 'package:tbsosick/presentation/controllers/sign_up_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core services
    Get.put(StorageService(), permanent: true);
    Get.put(ApiClient(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(UserDataRepository(), permanent: true);
    // Global controllers
    Get.put(InternetController(), permanent: true);

    // Services init
    ConnectivityService.init();

    Get.put(LoginController());
    Get.put(ForgatePasswordController());
    Get.put(ResetPasswordController());
    Get.put(SignUpController());
  }
}

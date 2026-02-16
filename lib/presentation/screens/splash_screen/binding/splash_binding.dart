import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/splash_screen/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
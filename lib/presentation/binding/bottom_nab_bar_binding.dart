import 'package:get/get.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';

class BottomNabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNabBarController());
  }
}
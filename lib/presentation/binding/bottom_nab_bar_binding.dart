import 'package:get/get.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/controllers/post_any__card_controller.dart';

class BottomNabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNabBarController());
    Get.put(HomePageController());
    
  }
}

class PostAnyCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostAnyCardController());
    
    
  }
}
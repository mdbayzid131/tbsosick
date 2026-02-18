import 'package:get/get.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/controllers/post_any__card_controller.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';

class BottomNabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNabBarController());
    Get.put(HomePageController());
    Get.put(PrefranceCardDetailsController());
  }
}

class PostAnyCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostAnyCardController());
    
    
  }
}

import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/my%20cards/controller/my_cards_controller.dart';

class MyCardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCardsController());
  }
}
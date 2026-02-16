import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';

class CardDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefranceCardDetailsController());
  }
}
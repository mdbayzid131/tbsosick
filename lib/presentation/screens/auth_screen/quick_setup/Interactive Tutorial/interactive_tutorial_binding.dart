import 'package:get/get.dart';
import '../../../../controllers/tutorial_controller.dart';

class InteractiveTutorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TutorialController());
  }
}


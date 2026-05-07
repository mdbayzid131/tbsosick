import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
  }
}

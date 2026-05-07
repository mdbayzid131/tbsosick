import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final RxInt selectedPlan = 1.obs;

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  void updatePaymentMethod() {
    // TODO: Implement update payment method logic
    // This could call a repository or navigate to another screen
  }
}

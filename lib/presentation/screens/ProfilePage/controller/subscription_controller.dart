import 'package:get/get.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/logger.dart';

class SubscriptionController extends GetxController {
  final IapService _iapService = Get.find<IapService>();
  
  final RxInt selectedPlan = 1.obs;
  final Rx<ProductDetails?> premiumProduct = Rx<ProductDetails?>(null);
  final Rx<ProductDetails?> enterpriseProduct = Rx<ProductDetails?>(null);

  @override
  void onInit() {
    super.onInit();
    _mapProducts();
  }

  void _mapProducts() {
    // ১. প্রথমে বর্তমানে থাকা ডাটা ম্যাপ করি
    _updateLocalProducts(_iapService.products);
    
    // ২. পরবর্তীতে কোনো চেঞ্জ হলে সেটিও ম্যাপ করি
    ever(_iapService.products, (List<ProductDetails> products) {
      _updateLocalProducts(products);
    });
  }

  void _updateLocalProducts(List<ProductDetails> products) {
    for (var product in products) {
      if (product.id == IapService.premiumMonthly) {
        premiumProduct.value = product;
        Helpers.debug('IAP: Controller mapped Premium product: ${product.price}');
      } else if (product.id == IapService.enterpriseMonthly) {
        enterpriseProduct.value = product;
        Helpers.debug('IAP: Controller mapped Enterprise product: ${product.price}');
      }
    }
  }

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  Future<void> subscribe() async {
    Helpers.debug('IAP: Subscribe called for plan index: ${selectedPlan.value}');
    final String userId = await StorageService.getString(StorageConstants.userId);
    if (userId.isEmpty) {
      Helpers.error('IAP: Error - User ID is empty');
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    ProductDetails? product;
    if (selectedPlan.value == 1) {
      product = premiumProduct.value;
    } else if (selectedPlan.value == 2) {
      product = enterpriseProduct.value;
    }

    Helpers.debug('IAP: Selected product: ${product?.id ?? 'NULL'}');

    if (product != null) {
      Helpers.info('IAP: Initiating buySubscription for ${product.id}');
      await _iapService.buySubscription(product, userId);
    } else if (selectedPlan.value != 0) {
      Helpers.error('IAP: Error - Product not found in store for selected plan');
      Get.snackbar('Error', 'Product not available in store');
    }
  }

  void updatePaymentMethod() {
    // IAP handles payment methods automatically via OS settings
  }
}

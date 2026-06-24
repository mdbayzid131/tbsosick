import 'package:get/get.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/subscription_model.dart';

class SubscriptionController extends GetxController with GetSingleTickerProviderStateMixin {
  final IapService _iapService = Get.find<IapService>();
  
  late TabController tabController;
  
  final RxInt selectedPlan = 1.obs; // 0: Free, 1: Premium, 2: Enterprise
  
  RxList<ProductDetails> get monthlyProducts => _iapService.monthlyProducts;
  RxList<ProductDetails> get yearlyProducts => _iapService.yearlyProducts;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  Future<void> subscribe() async {
    if (selectedPlan.value == 0) {
      await _iapService.chooseFreePlan();
      return;
    }

    Helpers.debug('IAP: Subscribe called for plan index: ${selectedPlan.value}');
    final String userId = await StorageService.getString(StorageConstants.userId);
    if (userId.isEmpty) {
      Helpers.error('IAP: Error - User ID is empty');
      Helpers.showError('User not logged in');
      return;
    }

    ProductDetails? product;
    final currentList = tabController.index == 0 ? monthlyProducts : yearlyProducts;
    
    // selectedPlan 1 -> Premium, 2 -> Enterprise
    // Since we mapped them securely, index 0 is always Premium, index 1 is Enterprise
    if (selectedPlan.value == 1 && currentList.isNotEmpty) {
      product = currentList[0];
    } else if (selectedPlan.value == 2 && currentList.length > 1) {
      product = currentList[1];
    }

    Helpers.debug('IAP: Selected product: ${product?.id ?? 'NULL'}');

    if (product != null) {
      if (_iapService.currentSubscription.value?.productId == product.id) {
        Helpers.showWarning('You are already subscribed to this plan.');
        return;
      }
      Helpers.info('IAP: Initiating buySubscription for ${product.id}');
      await _iapService.buySubscription(product, userId);
    } else {
      Helpers.error('IAP: Error - Product not found in store for selected plan');
      Helpers.showError('Product not available in store');
    }
  }

  Future<void> restorePurchases() async {
    await _iapService.restorePurchases();
  }

  bool get isSelectedPlanCurrent {
    final sub = _iapService.currentSubscription.value;
    if (sub == null) return false;

    if (selectedPlan.value == 0) return sub.plan == 'FREE';

    final currentList =
        tabController.index == 0 ? monthlyProducts : yearlyProducts;

    ProductDetails? product;
    if (selectedPlan.value == 1 && currentList.isNotEmpty) {
      product = currentList[0];
    } else if (selectedPlan.value == 2 && currentList.length > 1) {
      product = currentList[1];
    }

    if (product != null) {
      if (sub.productId == null) return false;
      // On Android, all products might have 'smrtscrub_subscription' as ID locally.
      // So checking sub.productId == product.id will wrongly return true for ALL plans.
      // Instead, we check the plan tier AND the interval (monthly/yearly) if available.
      if (Platform.isAndroid && product.id == 'smrtscrub_subscription') {
        final isPlanMatch = selectedPlan.value == 1 ? sub.plan.toUpperCase() == 'PREMIUM' : sub.plan.toUpperCase() == 'ENTERPRISE';
        final isIntervalMatch = sub.productId?.contains(tabController.index == 0 ? 'monthly' : 'yearly') ?? true;
        return isPlanMatch && isIntervalMatch;
      }
      return sub.productId == product.id || product.id.endsWith(sub.productId!);
    }
    return false;
  }

  SubscriptionModel? get currentSubscription =>
      _iapService.currentSubscription.value;
  bool get isLoading => _iapService.isLoading.value;
}

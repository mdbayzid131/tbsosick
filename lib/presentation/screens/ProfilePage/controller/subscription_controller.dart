import 'package:get/get.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/subscription_model.dart';

class SubscriptionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final IapService _iapService = Get.find<IapService>();

  late TabController tabController;

  final RxInt selectedPlan = 1.obs; // 0: Free, 1: Premium, 2: Enterprise

  RxList<ProductDetails> get monthlyProducts => _iapService.monthlyProducts;
  RxList<ProductDetails> get yearlyProducts => _iapService.yearlyProducts;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    final activeTier = currentPlanTier;
    if (activeTier > 0) {
      selectedPlan.value = activeTier;
      final sub = currentSubscription;
      if (sub?.productId?.contains('yearly') == true) {
        tabController.index = 1;
      }
    }

    ever(_iapService.currentSubscription, (sub) {
      final tier = currentPlanTier;
      if (tier > 0 && selectedPlan.value < tier) {
        selectedPlan.value = tier;
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  int getPlanTier(String? plan) {
    if (plan == null) return 0;
    final upper = plan.toUpperCase();
    if (upper.contains('ADMIN') || upper.contains('ENTERPRISE')) return 2;
    if (upper.contains('PREMIUM')) return 1;
    return 0; // FREE
  }

  int get currentPlanTier {
    final sub = _iapService.currentSubscription.value;
    if (sub == null) return 0;
    final statusUpper = sub.status.toUpperCase();
    if (statusUpper == 'EXPIRED' ||
        statusUpper == 'CANCELLED' ||
        statusUpper == 'INACTIVE') {
      return 0;
    }
    return getPlanTier(sub.plan);
  }

  bool get activeIsYearly {
    final sub = _iapService.currentSubscription.value;
    if (sub == null) return false;
    return sub.productId?.toLowerCase().contains('yearly') ?? false;
  }

  bool isPlanDisabled(int planIndex, {required bool isYearly}) {
    final activeTier = currentPlanTier; // 0: Free, 1: Premium, 2: Enterprise
    if (activeTier == 0) return false;

    // Rule:
    // - If user has Enterprise (tier 2): ALL plans are disabled.
    // - If user has Premium (tier 1): Premium is disabled (both monthly & yearly). Only Enterprise (tier 2) is allowed.
    return planIndex <= activeTier;
  }

  bool isPlanCurrent(int planIndex, {required bool isYearly}) {
    final activeTier = currentPlanTier;
    if (activeTier == 0) return planIndex == 0;
    return planIndex == activeTier && activeIsYearly == isYearly;
  }

  void selectPlan(int index) {
    final isYearly = tabController.index == 1;
    if (isPlanDisabled(index, isYearly: isYearly)) {
      return;
    }
    selectedPlan.value = index;
  }

  Future<void> subscribe() async {
    final isYearly = tabController.index == 1;
    if (isPlanDisabled(selectedPlan.value, isYearly: isYearly)) {
      return;
    }

    if (selectedPlan.value == 0) {
      await _iapService.chooseFreePlan();
      return;
    }

    Helpers.debug(
      'IAP: Subscribe called for plan index: ${selectedPlan.value}',
    );
    final String userId = await StorageService.getString(
      StorageConstants.userId,
    );
    if (userId.isEmpty) {
      Helpers.error('IAP: Error - User ID is empty');
      Helpers.showError('User not logged in');
      return;
    }

    ProductDetails? product;
    final currentList = tabController.index == 0
        ? monthlyProducts
        : yearlyProducts;

    // selectedPlan 1 -> Premium, 2 -> Enterprise
    if (selectedPlan.value == 1 && currentList.isNotEmpty) {
      product = currentList[0];
    } else if (selectedPlan.value == 2 && currentList.length > 1) {
      product = currentList[1];
    }

    Helpers.debug('IAP: Selected product: ${product?.id ?? 'NULL'}');

    if (product != null) {
      if (_iapService.currentSubscription.value?.productId == product.id &&
          isSelectedPlanCurrent) {
        Helpers.showWarning('You are already subscribed to this plan.');
        return;
      }
      Helpers.info('IAP: Initiating buySubscription for ${product.id}');
      String? expectedBasePlanId;
      if (Platform.isAndroid) {
        final isMonthly = tabController.index == 0;
        if (selectedPlan.value == 1) {
          expectedBasePlanId = isMonthly ? 'premium-monthly' : 'premium-yearly';
        } else if (selectedPlan.value == 2) {
          expectedBasePlanId = isMonthly
              ? 'enterprise-monthly'
              : 'enterprise-yearly';
        }
      }
      await _iapService.buySubscription(product, userId, expectedBasePlanId);
    } else {
      Helpers.error(
        'IAP: Error - Product not found in store for selected plan',
      );
      Helpers.showError('Product not available in store');
    }
  }

  Future<void> manageSubscription() async {
    try {
      final sub = currentSubscription;
      final productId = sub?.productId ?? '';

      Uri uri;
      if (Platform.isAndroid) {
        if (productId.isNotEmpty) {
          uri = Uri.parse(
            'https://play.google.com/store/account/subscriptions?sku=$productId&package=tbsosick',
          );
        } else {
          uri = Uri.parse(
            'https://play.google.com/store/account/subscriptions',
          );
        }
      } else if (Platform.isIOS) {
        uri = Uri.parse('https://apps.apple.com/account/subscriptions');
      } else {
        uri = Uri.parse('https://play.google.com/store/account/subscriptions');
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final fallbackUri = Uri.parse(
          'https://play.google.com/store/account/subscriptions',
        );
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Helpers.error('Error launching manage subscription URL: $e');
      Helpers.showError('Could not open subscription settings');
    }
  }

  Future<void> restorePurchases() async {
    await _iapService.restorePurchases();
  }

  bool get isSelectedPlanCurrent {
    final isYearly = tabController.index == 1;
    return isPlanCurrent(selectedPlan.value, isYearly: isYearly);
  }

  bool get isSelectedPlanDisabled {
    final isYearly = tabController.index == 1;
    return isPlanDisabled(selectedPlan.value, isYearly: isYearly);
  }

  SubscriptionModel? get currentSubscription =>
      _iapService.currentSubscription.value;
  bool get isLoading => _iapService.isLoading.value;
}

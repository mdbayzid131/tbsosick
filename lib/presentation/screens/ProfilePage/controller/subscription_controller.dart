import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/subscription_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

/// ============================================================================
/// SUBSCRIPTION CONTROLLER (SubscriptionController)
/// ============================================================================
/// Presentation controller connecting UI views with IapService. Handles tier
/// calculations, plan selection, checkout flow, onboarding auto-advance, and
/// store management links.
/// ============================================================================
class SubscriptionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final IapService _iapService = Get.find<IapService>();

  // ---------------------------------------------------------------------------
  // 1. STATE & CONTROLLERS
  // ---------------------------------------------------------------------------
  late TabController tabController;

  /// Selected plan index:
  /// 0 = Free Plan
  /// 1 = Premium Plan
  /// 2 = Enterprise Plan
  final RxInt selectedPlan = 1.obs;

  RxList<ProductDetails> get monthlyProducts => _iapService.monthlyProducts;
  RxList<ProductDetails> get yearlyProducts => _iapService.yearlyProducts;
  SubscriptionModel? get currentSubscription => _iapService.currentSubscription.value;
  bool get isLoading => _iapService.isLoading.value;

  // ---------------------------------------------------------------------------
  // 2. LIFECYCLE & ONBOARDING REACTIVITY
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // Default selection to current active tier if user has active plan
    final activeTier = currentPlanTier;
    if (activeTier > 0) {
      selectedPlan.value = activeTier;
      final sub = currentSubscription;
      if (sub?.productId?.contains('yearly') == true) {
        tabController.index = 1;
      }
    }

    // Reactive listener: Auto-advance onboarding when subscription activates
    ever(_iapService.currentSubscription, (sub) {
      final tier = currentPlanTier;
      if (tier > 0 && selectedPlan.value < tier) {
        selectedPlan.value = tier;
      }

      // Auto-navigate to next onboarding screen if user completes purchase during Quick Setup
      if (Get.currentRoute.contains(AppRoutes.selectPackage) && tier > 0) {
        Get.toNamed(AppRoutes.whatYourSpeciality);
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // 3. PLAN TIER & STATUS CALCULATIONS
  // ---------------------------------------------------------------------------

  /// Map plan string to numeric tier (0: Free, 1: Premium, 2: Enterprise)
  int getPlanTier(String? plan) {
    if (plan == null) return 0;
    final upper = plan.toUpperCase();
    if (upper.contains('ADMIN') || upper.contains('ENTERPRISE')) return 2;
    if (upper.contains('PREMIUM')) return 1;
    return 0;
  }

  /// Returns current active plan tier (0 if expired/cancelled/inactive)
  int get currentPlanTier {
    final sub = _iapService.currentSubscription.value;
    if (sub == null) return 0;
    
    final statusUpper = sub.status.toUpperCase();
    if (statusUpper == 'EXPIRED' ||
        statusUpper == 'CANCELLED' || // British spelling
        statusUpper == 'CANCELED' ||  // American Google Play spelling
        statusUpper == 'INACTIVE') {
      return 0;
    }
    return getPlanTier(sub.plan);
  }

  /// Checks if active plan billing cycle is yearly
  bool get activeIsYearly {
    final sub = _iapService.currentSubscription.value;
    if (sub == null) return false;
    return sub.productId?.toLowerCase().contains('yearly') ?? false;
  }

  /// Rules for disabling plan cards:
  /// - Enterprise (Tier 2): All cards disabled.
  /// - Premium (Tier 1): Premium disabled, Enterprise allowed.
  bool isPlanDisabled(int planIndex, {required bool isYearly}) {
    final activeTier = currentPlanTier;
    if (activeTier == 0) return false;
    return planIndex <= activeTier;
  }

  /// Checks if given plan index matches current active plan
  bool isPlanCurrent(int planIndex, {required bool isYearly}) {
    final activeTier = currentPlanTier;
    if (activeTier == 0) return planIndex == 0;
    return planIndex == activeTier && activeIsYearly == isYearly;
  }

  bool get isSelectedPlanCurrent {
    final isYearly = tabController.index == 1;
    return isPlanCurrent(selectedPlan.value, isYearly: isYearly);
  }

  bool get isSelectedPlanDisabled {
    final isYearly = tabController.index == 1;
    return isPlanDisabled(selectedPlan.value, isYearly: isYearly);
  }

  void selectPlan(int index) {
    final isYearly = tabController.index == 1;
    if (isPlanDisabled(index, isYearly: isYearly)) {
      return;
    }
    selectedPlan.value = index;
  }

  // ---------------------------------------------------------------------------
  // 4. SUBSCRIBE & FREE PLAN ACTIONS
  // ---------------------------------------------------------------------------

  /// Initiates subscription purchase or free plan selection
  Future<void> subscribe() async {
    final isYearly = tabController.index == 1;
    if (isPlanDisabled(selectedPlan.value, isYearly: isYearly)) {
      return;
    }

    // Free Plan selection
    if (selectedPlan.value == 0) {
      await _iapService.chooseFreePlan();
      return;
    }

    Helpers.debug('IAP: Subscribe called for plan index: ${selectedPlan.value}');

    // Fetch user ID from storage or fallback to profile API
    String userId = await StorageService.getString(StorageConstants.userId);
    if (userId.isEmpty) {
      try {
        final profileRes = await UserDataRepository().getProfile();
        if (profileRes.statusCode == 200 && profileRes.data?['data']?['id'] != null) {
          userId = profileRes.data['data']['id'].toString();
          await StorageService.setString(StorageConstants.userId, userId);
        }
      } catch (e) {
        Helpers.error('IAP: Profile fallback fetch error: $e');
      }
    }

    if (userId.isEmpty) {
      Helpers.error('IAP: Error - User ID is empty');
      Helpers.showError('User not logged in');
      return;
    }

    // Match product details from store query
    ProductDetails? product;
    final currentList = tabController.index == 0 ? monthlyProducts : yearlyProducts;

    if (selectedPlan.value == 1 && currentList.isNotEmpty) {
      product = currentList[0]; // Premium
    } else if (selectedPlan.value == 2 && currentList.length > 1) {
      product = currentList[1]; // Enterprise
    }

    if (product != null) {
      if (_iapService.currentSubscription.value?.productId == product.id && isSelectedPlanCurrent) {
        Helpers.showWarning('You are already subscribed to this plan.');
        return;
      }

      String? expectedBasePlanId;
      if (Platform.isAndroid) {
        final isMonthly = tabController.index == 0;
        if (selectedPlan.value == 1) {
          expectedBasePlanId = isMonthly ? 'premium-monthly' : 'premium-yearly';
        } else if (selectedPlan.value == 2) {
          expectedBasePlanId = isMonthly ? 'enterprise-monthly' : 'enterprise-yearly';
        }
      }

      await _iapService.buySubscription(product, userId, expectedBasePlanId);
    } else {
      Helpers.error('IAP: Product not found in store list');
      Helpers.showError('Product not available in store');
    }
  }

  /// Free Plan selection for Quick Setup Onboarding
  Future<void> chooseFreePlanAndProceed() async {
    try {
      await _iapService.chooseFreePlan();
    } catch (e) {
      Helpers.error('IAP: Error selecting free plan: $e');
    } finally {
      Get.toNamed(AppRoutes.whatYourSpeciality);
    }
  }

  // ---------------------------------------------------------------------------
  // 5. EXTERNAL URLS & RESTORE
  // ---------------------------------------------------------------------------

  /// Opens native subscription management (Google Play Account / Apple Subscriptions)
  Future<void> manageSubscription() async {
    try {
      final sub = currentSubscription;
      final productId = sub?.productId ?? '';

      Uri uri;
      if (Platform.isAndroid) {
        if (productId.isNotEmpty) {
          uri = Uri.parse(
            'https://play.google.com/store/account/subscriptions?sku=$productId&package=com.tbsosick.smrtscrub',
          );
        } else {
          uri = Uri.parse('https://play.google.com/store/account/subscriptions');
        }
      } else if (Platform.isIOS) {
        uri = Uri.parse('https://apps.apple.com/account/subscriptions');
      } else {
        uri = Uri.parse('https://play.google.com/store/account/subscriptions');
      }

      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        final fallbackUri = Uri.parse('https://play.google.com/store/account/subscriptions');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Helpers.error('IAP: Error launching manage subscription URL: $e');
      Helpers.showError('Could not open subscription settings');
    }
  }

  /// Opens legal documents (Terms of Service / Privacy Policy)
  Future<void> launchLegalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        Helpers.error('Could not launch legal URL: $url');
      }
    } catch (e) {
      Helpers.error('Error launching legal URL: $e');
    }
  }

  /// Triggers In-App Purchase restoration
  Future<void> restorePurchases() async {
    await _iapService.restorePurchases();
  }
}

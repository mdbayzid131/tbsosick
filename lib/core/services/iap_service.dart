import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:uuid/uuid.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/core/utils/subscription_helper.dart';
import 'package:tbsosick/data/models/subscription_model.dart';
import 'package:tbsosick/core/services/auth_service.dart';

class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Observables
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<SubscriptionModel?> currentSubscription = Rx<SubscriptionModel?>(
    null,
  );

  bool get isPremiumUser => currentSubscription.value?.isPremium ?? false;

  // Product IDs (Android Base Plans)
  static const String premiumMonthly = 'premium-monthly';
  static const String premiumYearly = 'premium-yearly';
  static const String enterpriseMonthly = 'enterprise-monthly';
  static const String enterpriseYearly = 'enterprise-yearly';

  // Product IDs (iOS App Store Connect)
  // Apple sometimes blocks hyphens or requires unique naming.
  static const String iosPremiumMonthly = 'com.tbsosick.premium_monthly';
  static const String iosPremiumYearly = 'com.tbsosick.premium_yearly';
  static const String iosEnterpriseMonthly = 'com.tbsosick.enterprise_monthly';
  static const String iosEnterpriseYearly = 'com.tbsosick.enterprise_yearly';

  List<String> get _productIds {
    if (Platform.isAndroid) {
      // Query the main subscription container. Google Play will return multiple
      // ProductDetails (one for each base plan), all with the same ID.
      return ['smrtscrub_subscription'];
    } else {
      return [
        iosPremiumMonthly,
        iosPremiumYearly,
        iosEnterpriseMonthly,
        iosEnterpriseYearly,
      ];
    }
  }

  // Buyer Binding Namespace from Guide
  static const String _iapNamespace = 'b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32';

  @override
  void onInit() {
    super.onInit();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => Helpers.debug('IAP Error: $error'),
    );

    // Watch login state to sync/clear subscription
    ever(Get.find<AuthService>().isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        syncSubscriptionWithBackend();
      } else {
        currentSubscription.value = null;
      }
    });

    initialize();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> initialize() async {
    Helpers.debug('IAP: Initializing...');
    final bool available = await _iap.isAvailable();
    Helpers.debug('IAP: Store available: $available');
    if (!available) {
      Helpers.debug('IAP: Store not available on this device');
      return;
    }
    await fetchProducts();

    // Only sync with backend if user is already logged in
    if (Get.find<AuthService>().isAuthenticated) {
      await syncSubscriptionWithBackend();
    }
  }

  Future<void> syncSubscriptionWithBackend() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getData(ApiConstants.getMySubscription);

      if (response.statusCode == 200 && response.data['data'] != null) {
        currentSubscription.value = SubscriptionModel.fromJson(
          response.data['data'],
        );
        Helpers.info('IAP: Current Plan: ${currentSubscription.value?.plan}');
      }
    } catch (e) {
      Helpers.error('IAP: Error syncing subscription: $e');
    }
  }

  Future<void> chooseFreePlan() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.postData(
        ApiConstants.chooseFreePlan,
        {},
      );

      if (response.statusCode == 200) {
        await syncSubscriptionWithBackend();
        Helpers.showSuccess('Free plan selected');
      } else if (response.statusCode == 409) {
        final message =
            response.data['message'] ??
            'You have an active store subscription.';
        SubscriptionHelper.showSubscriptionDialog(
          title: 'Active Subscription Found',
          message: message,
          onPress: () {
            Get.back();
            //
          },
          buttonText: 'Back',
        );
      }
    } catch (e) {
      Helpers.error('IAP: Error selecting free plan: $e');
    }
  }

  Future<void> fetchProducts() async {
    Helpers.debug('IAP: Fetching products for IDs: $_productIds');
    isLoading.value = true;
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        _productIds.toSet(),
      );

      Helpers.debug(
        'IAP: Fetch result - Found: ${response.productDetails.length}, Not Found: ${response.notFoundIDs}',
      );

      if (response.error != null) {
        Helpers.error('IAP: Fetch Error: ${response.error!.message}');
      }

      if (response.productDetails.isEmpty) {
        Helpers.warning(
          'IAP: No products were found in the store. Check your SKUs/IDs.',
        );
      }

      products.assignAll(response.productDetails);
      for (var prod in response.productDetails) {
        String androidInfo = '';
        if (Platform.isAndroid && prod is GooglePlayProductDetails) {
          final offers = prod.productDetails.subscriptionOfferDetails;
          final allBasePlans = offers?.map((e) => e.basePlanId).toList();
          final offerIds = offers?.map((e) => e.offerId).toList();
          final offerIdsToken = offers?.map((e) => e.offerIdToken).toList();
          final offerTags = offers?.map((e) => e.offerTags).toList();
          final offerId = offers?.map((e) => e.installmentPlanDetails).toList();
          final pricingPhases = offers?.map((e) => e.pricingPhases).toList();
          final priceCurrencyCode = offers
              ?.map((e) => e.pricingPhases.map((e) => e.priceCurrencyCode))
              .toList();

          // Let's try to see if there's a specific offer index or token in the product details wrapper
          androidInfo = ' | All Base Plans in Wrapper: $allBasePlans';

          print("offerIds: $offerIds");
          print("offerIdsToken: $offerIdsToken");
          print("offerTags: $offerTags");
          print("offerId: $offerId");
          print("pricingPhases: $pricingPhases");
          print("priceCurrencyCode: $priceCurrencyCode");
        }
        Helpers.debug(
          'IAP: Loaded Product: ID: ${prod.id}, Price: ${prod.price}$androidInfo',
        );
      }
    } catch (e) {
      Helpers.error('IAP: Exception during fetch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Derives the deterministic UUIDv5 for Buyer Binding
  String deriveIapAccountToken(String userId) {
    return const Uuid().v5(_iapNamespace, userId);
  }

  Future<void> buySubscription(
    ProductDetails product,
    String userId, [
    String? expectedBasePlanId,
  ]) async {
    final String accountToken = deriveIapAccountToken(userId);

    if (expectedBasePlanId != null) {
      await StorageService.setString('pending_purchase_id', expectedBasePlanId);
    }

    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        applicationUserName: accountToken, // maps to obfuscatedAccountId
      );
    } else {
      purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName:
            accountToken, // For iOS fallback, or use MethodChannel for SK2
      );
    }

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      Helpers.debug('Error initiating purchase: $e');
    }
  }

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    try {
      for (var purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.pending) {
          // Show loading or pending UI
        } else if (purchase.status == PurchaseStatus.error) {
          final errorMsg = purchase.error?.message ?? '';
          if (errorMsg.contains('itemAlreadyOwned') ||
              errorMsg.contains('BillingResponse.itemAlreadyOwned')) {
            Helpers.showWarning(
              'Item already owned. Please use the Restore button to sync your plan.',
            );
          } else {
            Helpers.error('Purchase Error: ${purchase.error}');
          }

          try {
            if (purchase is GooglePlayPurchaseDetails) {
              await _iap.completePurchase(purchase);
            } else if (purchase is AppStorePurchaseDetails) {
              await _iap.completePurchase(purchase);
            }
          } catch (e) {
            Helpers.debug(
              'IAP: completePurchase error (expected if not platform-specific): $e',
            );
          }
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          await _verifyPurchase(purchase);
        }
      }
    } catch (e) {
      Helpers.error('IAP: Exception in _onPurchaseUpdate: $e');
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      final apiClient = Get.find<ApiClient>();
      dynamic response;

      if (Platform.isIOS) {
        // iOS: Send signedTransactionInfo (JWS)
        response = await apiClient
            .postData('${ApiConstants.subscriptionBaseUrl}/apple/verify', {
              'platform': 'ios',
              'signedTransactionInfo':
                  purchase.verificationData.serverVerificationData,
            });
      } else if (Platform.isAndroid) {
        String basePlanId = '';
        // If Android returns the generic subscription ID, we fetch the specific base plan ID we cached.
        if (purchase.productID == 'smrtscrub_subscription') {
          final pendingId = await StorageService.getString(
            'pending_purchase_id',
          );
          if (pendingId.isNotEmpty) {
            basePlanId = pendingId;
          }
        }

        // Android: Send purchaseToken, generic productId, and selectedBasePlanId
        response = await apiClient
            .postData('${ApiConstants.subscriptionBaseUrl}/google/verify', {
              'platform': 'android',
              'productId': purchase.productID,
              'selectedBasePlanId': basePlanId,
              'purchaseToken': purchase.verificationData.serverVerificationData,
            });
      }

      if (response != null && response.statusCode == 200) {
        Helpers.info('Purchase verified successfully');
        if (Platform.isAndroid && purchase is GooglePlayPurchaseDetails) {
          await _iap.completePurchase(purchase);
        } else if (Platform.isIOS && purchase is AppStorePurchaseDetails) {
          await _iap.completePurchase(purchase);
        }
        await syncSubscriptionWithBackend();
      } else {
        // If the transaction was superseded by an upgrade, we should still complete it
        // so the store stops sending it to us.
        final errorMessage = response?.data?['message']?.toString() ?? '';
        if (errorMessage.contains('superseded by an upgrade') ||
            errorMessage.contains('already expired')) {
          Helpers.warning(
            'Transaction $errorMessage. Completing to stop retries.',
          );
          if (Platform.isIOS && purchase is AppStorePurchaseDetails) {
            await _iap.completePurchase(purchase);
          }
          await syncSubscriptionWithBackend();
        } else {
          Helpers.debug('Verification failed: $errorMessage');
        }
      }
    } catch (e) {
      Helpers.error('Error verifying purchase: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      await _iap.restorePurchases();
      // Sync with backend to get the latest status after restoration
      await syncSubscriptionWithBackend();
      Helpers.showSuccess(
        'Subscription restore initiated. Please wait a moment.',
      );
    } catch (e) {
      Helpers.error('Error restoring purchases: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

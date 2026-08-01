import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
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

/// ============================================================================
/// IN-APP PURCHASE SERVICE (IapService)
/// ============================================================================
/// Manages native store queries (Google Play Billing & App StoreKit), purchase
/// updates listener, backend receipt verification, and entitlement status.
/// ============================================================================
class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // ---------------------------------------------------------------------------
  // 1. OBSERVABLES & STATE
  // ---------------------------------------------------------------------------
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxList<ProductDetails> monthlyProducts = <ProductDetails>[].obs;
  final RxList<ProductDetails> yearlyProducts = <ProductDetails>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<SubscriptionModel?> currentSubscription = Rx<SubscriptionModel?>(
    null,
  );

  /// Returns true if user has an active Premium or Enterprise plan
  bool get isPremiumUser => currentSubscription.value?.isPremium ?? false;

  // ---------------------------------------------------------------------------
  // 2. PRODUCT SKUs & BASE PLAN IDENTIFIERS
  // ---------------------------------------------------------------------------
  // Android Base Plans
  static const String premiumMonthly = 'premium-monthly';
  static const String premiumYearly = 'premium-yearly';
  static const String enterpriseMonthly = 'enterprise-monthly';
  static const String enterpriseYearly = 'enterprise-yearly';

  // iOS App Store Product IDs
  static const String iosPremiumMonthly = 'com.tbsosick.premium_monthly';
  static const String iosPremiumYearly = 'com.tbsosick.premium_yearly';
  static const String iosEnterpriseMonthly = 'com.tbsosick.enterprise_monthly';
  static const String iosEnterpriseYearly = 'com.tbsosick.enterprise_yearly';

  /// Buyer Binding Namespace for deterministic UUIDv5 generation
  static const String _iapNamespace = 'b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32';

  List<String> get _productIds {
    if (Platform.isAndroid) {
      // Query subscription container SKU on Google Play Console
      return ['smrtscrub_subscription'];
    } else {
      // Query distinct product IDs on Apple App Store Connect
      return [
        iosPremiumMonthly,
        iosPremiumYearly,
        iosEnterpriseMonthly,
        iosEnterpriseYearly,
      ];
    }
  }

  // ---------------------------------------------------------------------------
  // 3. SERVICE LIFECYCLE
  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();

    // Listen to native purchase stream (StoreKit & Google Play Billing)
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => Helpers.debug('IAP Stream Error: $error'),
    );

    // Watch authentication state to automatically sync/clear subscription data
    ever(Get.find<AuthService>().isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        syncSubscriptionWithBackend();
      } else {
        currentSubscription.value = null;
      }
    });

    // Automatically update mapped monthly/yearly product lists when products change
    ever(products, (List<ProductDetails> productsList) {
      _updateLocalProducts(productsList);
    });

    initialize();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  /// Initialize store connection, fetch products, and sync subscription state
  Future<void> initialize() async {
    Helpers.debug('IAP: Initializing service...');
    final bool available = await _iap.isAvailable();
    Helpers.debug('IAP: Store availability status: $available');

    if (!available) {
      Helpers.debug('IAP: Store not available on this device');
      return;
    }

    await fetchProducts();

    if (Get.find<AuthService>().isAuthenticated) {
      await syncSubscriptionWithBackend();
    }
  }

  // ---------------------------------------------------------------------------
  // 4. BACKEND SYNC & FREE PLAN SELECTION
  // ---------------------------------------------------------------------------

  /// Syncs user's active subscription status from backend database
  Future<void> syncSubscriptionWithBackend() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getData(ApiConstants.getMySubscription);

      if (response.statusCode == 200 && response.data['data'] != null) {
        currentSubscription.value = SubscriptionModel.fromJson(
          response.data['data'],
        );
        Helpers.info(
          'IAP: Current Active Plan: ${currentSubscription.value?.plan}',
        );
      }
    } catch (e) {
      Helpers.error('IAP: Exception during subscription sync: $e');
    }
  }

  /// Selects Free Plan on backend
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
          onPress: () => Get.back(),
          buttonText: 'Back',
        );
      }
    } catch (e) {
      Helpers.error('IAP: Exception selecting free plan: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 5. FETCH STORE PRODUCTS
  // ---------------------------------------------------------------------------

  /// Queries native store for registered product details and pricing
  Future<void> fetchProducts() async {
    Helpers.debug('IAP: Querying store products: $_productIds');
    isLoading.value = true;
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        _productIds.toSet(),
      );

      if (response.error != null) {
        Helpers.error('IAP: Query Error: ${response.error!.message}');
      }

      products.assignAll(response.productDetails);
      for (var prod in response.productDetails) {
        Helpers.debug(
          'IAP: Loaded Product SKU: ${prod.id}, Price: ${prod.price}',
        );
      }
    } catch (e) {
      Helpers.error('IAP: Exception during fetchProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Derives deterministic UUIDv5 token for Obfuscated Account ID (Buyer Binding)
  String deriveIapAccountToken(String userId) {
    return const Uuid().v5(_iapNamespace, userId);
  }

  // ---------------------------------------------------------------------------
  // 6. PURCHASE FLOW & LISTENER
  // ---------------------------------------------------------------------------

  GooglePlayPurchaseDetails? activeGooglePurchaseDetails;

  /// Initiates native purchase flow for selected product
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
      ChangeSubscriptionParam? changeParam;
      if (activeGooglePurchaseDetails != null) {
        changeParam = ChangeSubscriptionParam(
          oldPurchaseDetails: activeGooglePurchaseDetails!,
          replacementMode: ReplacementMode.withTimeProration,
        );
      }

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        applicationUserName: accountToken,
        changeSubscriptionParam: changeParam,
      );
    } else {
      purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: accountToken,
      );
    }

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      Helpers.debug('IAP: Error initiating buyNonConsumable: $e');
    }
  }

  /// Handles incoming purchase update events from native store stream
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    try {
      for (var purchase in purchaseDetailsList) {
        if (purchase is GooglePlayPurchaseDetails &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)) {
          activeGooglePurchaseDetails = purchase;
        }

        if (purchase.status == PurchaseStatus.pending) {
          // Transaction pending completion
        } else if (purchase.status == PurchaseStatus.error) {
          final errorMsg = purchase.error?.message ?? '';
          if (errorMsg.contains('itemAlreadyOwned') ||
              errorMsg.contains('BillingResponse.itemAlreadyOwned')) {
            Helpers.showWarning(
              'Item already owned. Please use the Restore button to sync your plan.',
            );
          } else {
            Helpers.error('IAP: Purchase Error: ${purchase.error}');
            final message = purchase.error?.message ?? '';
            if (!message.toLowerCase().contains('cancel') &&
                !message.toLowerCase().contains('user_canceled') &&
                !message.toLowerCase().contains('user_cancelled')) {
              Helpers.showError(_getFriendlyIapErrorMessage(purchase.error));
            }
          }

          try {
            if (purchase is GooglePlayPurchaseDetails) {
              await _iap.completePurchase(purchase);
            } else if (purchase is AppStorePurchaseDetails) {
              await _iap.completePurchase(purchase);
            }
          } catch (e) {
            Helpers.debug('IAP: completePurchase error: $e');
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

  /// Translates raw technical IAP error strings into user-friendly messages
  String _getFriendlyIapErrorMessage(IAPError? error) {
    if (error == null) return 'Unable to complete purchase. Please try again.';
    final msg = error.message.toLowerCase();
    final code = error.code.toLowerCase();

    if (msg.contains('developererror') || code.contains('developererror')) {
      return 'Billing setup is incomplete or unavailable for this build. Please try again later.';
    } else if (msg.contains('billingunavailable') ||
        code.contains('billingunavailable')) {
      return 'Google Play Billing is currently unavailable on your device.';
    } else if (msg.contains('itemunavailable') ||
        code.contains('itemunavailable')) {
      return 'This subscription plan is currently unavailable for purchase.';
    } else if (msg.contains('serviceunavailable') ||
        code.contains('serviceunavailable')) {
      return 'Unable to connect to Google Play Store. Please check your internet connection.';
    } else if (msg.contains('networkerror') || code.contains('networkerror')) {
      return 'Network error occurred during purchase. Please check your connection and try again.';
    }
    return 'Purchase could not be completed. Please try again.';
  }

  /// Verifies purchase token/receipt with backend API
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      final String purchaseToken =
          purchase.verificationData.serverVerificationData;

      // Guard: If purchase token is empty (e.g. after cancellation), skip verify API call
      if (purchaseToken.isEmpty) {
        Helpers.warning(
          'IAP: Purchase token is empty, syncing subscription status directly.',
        );
        await syncSubscriptionWithBackend();
        return;
      }

      final apiClient = Get.find<ApiClient>();
      dynamic response;

      if (Platform.isIOS) {
        // iOS: Send signedTransactionInfo (JWS)
        response = await apiClient.postData(ApiConstants.verifyApplePurchase, {
          'platform': 'ios',
          'signedTransactionInfo': purchaseToken,
        });
      } else if (Platform.isAndroid) {
        String basePlanId = '';
        if (purchase.productID == 'smrtscrub_subscription') {
          final pendingId = await StorageService.getString(
            'pending_purchase_id',
          );
          if (pendingId.isNotEmpty) {
            basePlanId = pendingId;
          }
        }

        // Android: Send purchaseToken, generic productId, and selectedBasePlanId
        response = await apiClient.postData(ApiConstants.verifyGooglePurchase, {
          'platform': 'android',
          'productId': purchase.productID,
          'selectedBasePlanId': basePlanId,
          'purchaseToken': purchaseToken,
        });
      }

      if (response != null && response.statusCode == 200) {
        Helpers.info('IAP: Purchase verified successfully');
        await StorageService.setString('pending_purchase_id', '');
        if (Platform.isAndroid && purchase is GooglePlayPurchaseDetails) {
          await _iap.completePurchase(purchase);
        } else if (Platform.isIOS && purchase is AppStorePurchaseDetails) {
          await _iap.completePurchase(purchase);
        }
        await syncSubscriptionWithBackend();
      } else {
        final errorMessage = response?.data?['message']?.toString() ?? '';
        final isConflictOrUpgrade =
            response?.statusCode == 409 ||
            errorMessage.contains('higher priority enterprise') ||
            errorMessage.contains('superseded by an upgrade') ||
            errorMessage.contains('already expired');

        if (isConflictOrUpgrade) {
          Helpers.warning(
            'Transaction notice: $errorMessage. Completing transaction.',
          );
          await StorageService.setString('pending_purchase_id', '');
          if (Platform.isAndroid && purchase is GooglePlayPurchaseDetails) {
            await _iap.completePurchase(purchase);
          } else if (Platform.isIOS && purchase is AppStorePurchaseDetails) {
            await _iap.completePurchase(purchase);
          }
          await syncSubscriptionWithBackend();
          if (response?.statusCode == 409 ||
              errorMessage.contains('higher priority')) {
            Helpers.showWarning(
              'You already hold a higher priority active entitlement.',
            );
          }
        } else {
          Helpers.debug('IAP: Verification failed: $errorMessage');
          Helpers.showError('Subscription verification failed: $errorMessage');
        }
      }
    } catch (e) {
      Helpers.error('IAP: Error verifying purchase: $e');
      Helpers.showError('Purchase verification failed. Please try again.');
    }
  }

  // ---------------------------------------------------------------------------
  // 7. RESTORE PURCHASES
  // ---------------------------------------------------------------------------

  /// Triggers store purchase restoration for registered account purchases
  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      await _iap.restorePurchases();
      await syncSubscriptionWithBackend();
      Helpers.showSuccess(
        'Subscription restore initiated. Please wait a moment.',
      );
    } catch (e) {
      Helpers.error('IAP: Error restoring purchases: $e');
      Helpers.showError('Failed to restore purchases: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 8. PRODUCT MAPPING & SORTING
  // ---------------------------------------------------------------------------
  void _updateLocalProducts(List<ProductDetails> productsList) {
    if (productsList.isEmpty) return;

    if (Platform.isAndroid &&
        productsList.every((p) => p.id == 'smrtscrub_subscription')) {
      // Android sorting by raw price:
      // Premium Monthly < Enterprise Monthly < Premium Yearly < Enterprise Yearly
      final sortedProducts = List<ProductDetails>.from(productsList);
      sortedProducts.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

      if (sortedProducts.length >= 4) {
        monthlyProducts.assignAll([sortedProducts[0], sortedProducts[1]]);
        yearlyProducts.assignAll([sortedProducts[2], sortedProducts[3]]);
      } else if (sortedProducts.length >= 2) {
        monthlyProducts.assignAll([sortedProducts[0]]);
        yearlyProducts.assignAll([sortedProducts[1]]);
      } else if (sortedProducts.isNotEmpty) {
        monthlyProducts.assignAll([sortedProducts[0]]);
      }
    } else {
      // Original logic for iOS or distinct SKUs
      final List<ProductDetails> monthly = [];
      final List<ProductDetails> yearly = [];

      for (var product in productsList) {
        final lowerId = product.id.toLowerCase();
        if (lowerId.contains('monthly')) {
          monthly.add(product);
        } else if (lowerId.contains('yearly')) {
          yearly.add(product);
        }
      }

      // Safe strict-weak ordering comparator to prevent ComparisonContractViolationException
      int comparePremiumFirst(ProductDetails a, ProductDetails b) {
        final aPremium = a.id.toLowerCase().contains('premium');
        final bPremium = b.id.toLowerCase().contains('premium');
        if (aPremium && !bPremium) return -1;
        if (!aPremium && bPremium) return 1;
        return a.id.compareTo(b.id);
      }

      monthly.sort(comparePremiumFirst);
      yearly.sort(comparePremiumFirst);

      monthlyProducts.assignAll(monthly);
      yearlyProducts.assignAll(yearly);
    }

    Helpers.debug(
      'IAP: Service mapped ${monthlyProducts.length} monthly and ${yearlyProducts.length} yearly products',
    );
  }
}

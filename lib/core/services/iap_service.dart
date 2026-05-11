import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:tbsosick/core/services/api_client.dart';

class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Observables
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isLoading = false.obs;

  // Product IDs from Guide
  static const String premiumMonthly = 'premium_monthly';
  static const String premiumYearly = 'premium_yearly';
  static const String enterpriseMonthly = 'enterprise_monthly';
  static const String enterpriseYearly = 'enterprise_yearly';

  static const List<String> _productIds = [
    premiumMonthly,
    premiumYearly,
    enterpriseMonthly,
    enterpriseYearly,
  ];

  // Buyer Binding Namespace from Guide
  static const String _iapNamespace = 'b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32';

  @override
  void onInit() {
    super.onInit();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => AppLogger.debug('IAP Error: $error'),
    );
    initialize();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> initialize() async {
    AppLogger.debug('IAP: Initializing...');
    final bool available = await _iap.isAvailable();
    AppLogger.debug('IAP: Store available: $available');
    if (!available) {
      AppLogger.debug('IAP: Store not available on this device');
      return;
    }
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
    AppLogger.debug('IAP: Fetching products for IDs: $_productIds');
    isLoading.value = true;
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_productIds.toSet());
      
      AppLogger.debug('IAP: Fetch result - Found: ${response.productDetails.length}, Not Found: ${response.notFoundIDs}');
      
      if (response.error != null) {
        AppLogger.debug('IAP: Fetch Error: ${response.error!.message}');
      }
      
      if (response.productDetails.isEmpty) {
        AppLogger.debug('IAP: No products were found in the store. Check your SKUs/IDs.');
      }

      products.assignAll(response.productDetails);
      for (var prod in response.productDetails) {
        AppLogger.debug('IAP: Loaded Product: ${prod.id} - ${prod.price}');
      }
    } catch (e) {
      AppLogger.debug('IAP: Exception during fetch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Derives the deterministic UUIDv5 for Buyer Binding
  String deriveIapAccountToken(String userId) {
    return const Uuid().v5(_iapNamespace, userId);
  }

  Future<void> buySubscription(ProductDetails product, String userId) async {
    final String accountToken = deriveIapAccountToken(userId);

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
      AppLogger.debug('Error initiating purchase: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show loading or pending UI
      } else if (purchase.status == PurchaseStatus.error) {
        AppLogger.debug('Purchase Error: ${purchase.error}');
        _iap.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _verifyPurchase(purchase);
      }
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
              'signedTransactionInfo':
                  purchase.verificationData.serverVerificationData,
            });
      } else if (Platform.isAndroid) {
        // Android: Send purchaseToken and productId
        response = await apiClient
            .postData('${ApiConstants.subscriptionBaseUrl}/google/verify', {
              'purchaseToken': purchase.verificationData.serverVerificationData,
              'productId': purchase.productID,
            });
      }

      if (response != null && response.statusCode == 200) {
        AppLogger.debug('Purchase verified successfully');
        await _iap.completePurchase(purchase);
        // Refresh user subscription status here
      } else {
        AppLogger.debug('Verification failed');
      }
    } catch (e) {
      AppLogger.debug('Error verifying purchase: $e');
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}

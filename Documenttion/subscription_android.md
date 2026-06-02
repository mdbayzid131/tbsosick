# In-App Purchases & Subscriptions (Android) Guide (অ্যান্ড্রয়েড ইন-অ্যাপ পারচেস গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে অ্যান্ড্রয়েড গুগল প্লে বিলিং (Google Play Billing) ব্যবহার করে সাবস্ক্রিপশন বাস্তবায়ন এবং ব্যাকএন্ড এপিআই ভেরিফিকেশন সেটআপ সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
SMRTSCRUB অ্যাপে অ্যান্ড্রয়েড ব্যবহারকারীদের প্রিমিয়াম সাবস্ক্রিপশন ফিচার প্রদানের জন্য গুগল প্লে বিলিং ব্যবহার করা হয়। অ্যাপটি গুগল প্লে থেকে সচল প্রোডাক্ট লিস্ট ক্যাচ করে, পেমেন্ট শিট ওপেন করে এবং ট্রানজেকশন সফল হলে পেমেন্ট রিসিট বা টোকেন ব্যাকএন্ড এপিআই-তে যাচাইয়ের জন্য পাঠায়। ব্যাকএন্ড সরাসরি গুগলের সার্ভারের সাথে পেমেন্ট কনফার্ম করে তবেই ইউজারের প্রিমিয়াম এক্সেস অন করে।

---

# Architecture (আর্কিটেকচার)
```
[User] ──(প্ল্যান সিলেক্ট করে)──> [IapService] ──> লোকাল UserId থেকে Buyer Token জেনারেট করে
                                                 │
                                                 ├──> গুগল প্লে পেমেন্ট শীট ওপেন করে
                                                 ├──> পেমেন্ট শেষে PurchaseToken রিসিভ করে
                                                 └──> [IapService._verifyPurchase()]
                                                          │
                                                          └──> POST /subscriptions/google/verify
                                                               │
                                                               └──> ব্যাকএন্ড গুগল প্লে এপিআই কল করে
                                                                    (পেমেন্ট কনফার্মেশন ও ভ্যালিডিটি ডাটা ব্যাক করে)
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/iap_service.dart` - প্রোডাক্ট লিস্ট কোয়েরি করা, পেমেন্ট ট্রিগার করা, ওটিপি বাইন্ড করা এবং পেমেন্ট শেষে সাকসেস ইভেন্ট লিসেন করার মূল ক্লাস ফাইল।
*   `lib/core/bindings/initial_binding.dart` - অ্যাপের গ্লোবাল বাইন্ডিং সেটিংস যেখানে `IapService` চিরস্থায়ীভাবে রান করা হয়।
*   `lib/config/constants/api_constants.dart` - অ্যান্ড্রয়েড ভেরিফিকেশন পাথ (`/subscriptions/google/verify`) সংজ্ঞায়িত করার ফাইল।
*   `lib/presentation/screens/ProfilePage/controller/subscription_controller.dart` - ইউআই পেজে পেমেন্ট স্টেট ও প্রোডাক্ট সেটিংস কন্ট্রোলার।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  in_app_purchase: ^3.1.13
  in_app_purchase_android: ^0.4.0+10
  uuid: ^4.5.2
  get: ^4.7.3
```
*   `in_app_purchase`: গুগল প্লে বিলিং ক্লায়েন্ট র্যাপ করার মূল প্লাগইন।
*   `uuid`: ইউজারের পরিচয় হাইড করে ক্রিপ্টোগ্রাফিক ইউনিক Buyer Token জেনারেট করার লাইব্রেরি।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (লোকাল গুগল প্লে সাবস্ক্রিপশনের জন্য কোনো Firebase কনফিগারেশনের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Google Play Console Developer Account:** প্রজেক্ট রিলিজ করতে, প্রিমিয়াম প্রোডাক্ট আইডি লিস্ট তৈরি করতে, টেস্টিং এক্সেস দিতে এবং এপিআই পারমিশন কি জেনারেট করতে অ্যাডমিন ডেভেলপার অ্যাকাউন্ট প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Google Developer Service Account Key:** ব্যাকএন্ড সার্ভার থেকে গুগলের ভেরিফিকেশন এপিআই কল করার জন্য প্রয়োজনীয় প্রাইভেট JSON কী-স্টোর ফাইল।
*   **IAP Namespace ID:** ক্লায়েন্ট ডিভাইসে ইউজারের আইডি থেকে ডেটার সিকিউর Buyer Token ডেরিভ করার জন্য কাস্টম Namespace স্ট্রিং।
    *   *Real Project Value:* `b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32`

---

## Client Access Required

### Firebase
- Owner Email
- Admin Access
- Project ID

### Google Play Console
- Admin Access
- Package Name

### Apple Developer
- Team ID
- Key ID
- Bundle ID

### Backend
- Base URL
- Staging URL
- Production URL
- Socket URL

### Third Party
- Stripe
- RevenueCat
- Agora
- OneSignal

---

# Implementation Steps (বাস্তবায়নের ধাপসমূহ)

### ধাপ ১: প্লে কনসোলে অ্যাপ বান্ডেল আপলোড করা
গুগল প্লে স্টোরে সাবস্ক্রিপশন প্রোডাক্ট রেজিস্টার করার আগে কমপক্ষে একবার অ্যাপ বান্ডেল তৈরি করে ক্লোজড বা ইন্টারনাল ট্র্যাক-এ আপলোড করতে হবে:
```bash
flutter clean && flutter pub get
flutter build appbundle
```
জেনারেট হওয়া `build/app/outputs/bundle/release/app-release.aab` ফাইলটি গুগল প্লে কনসোলের **Testing → Internal Testing** ট্যাবে আপলোড করুন।

### ধাপ ২: গুগল প্লে কনসোলে সাবস্ক্রিপশন প্রোডাক্ট তৈরি করা
প্লে কনসোলের **Monetize → Subscriptions** সেকশনে গিয়ে অ্যাপের জন্য প্রোডাক্ট তৈরি করে স্ট্যাটাস "Active" করুন:

| Product ID | Reference Name | Duration | Status |
|---|---|---|---|
| `premium_monthly` | Premium Monthly | 1 Month | Active |
| `premium_yearly` | Premium Yearly | 1 Year | Active |
| `enterprise_monthly` | Enterprise Monthly | 1 Month | Active |
| `enterprise_yearly` | Enterprise Yearly | 1 Year | Active |

### ধাপ ৩: গুগল ক্লাউড এপিআই এবং সার্ভিস অ্যাকাউন্ট কনফিগার করা
পেমেন্ট কনফার্ম করতে ব্যাকএন্ডের জন্য এপিআই এবং পারমিশন কি তৈরি করতে হবে:
1. Google Cloud Console-এ গিয়ে প্রজেক্ট সিলেক্ট করুন।
2. **APIs & Services → Library**-তে গিয়ে **Google Play Android Developer API** সার্চ করে ইনেবল করুন।
3. **IAM & Admin → Service Accounts**-এ গিয়ে একটি সার্ভিস অ্যাকাউন্ট তৈরি করুন: `play-billing-service@<PROJECT-ID>.iam.gserviceaccount.com`। এরপর এটার অধীনে একটি **JSON Key** জেনারেট করে ডাউনলোড করুন।
4. Google Play Console-এর **Users and permissions → Invite new users**-এ গিয়ে তৈরি করা সার্ভিস অ্যাকাউন্ট ইমেলটি অ্যাড করুন এবং নিচের পারমিশন দিন:
    *   ✅ **View financial data, orders, and cancellation survey responses**
    *   ✅ **Manage orders and subscriptions**
5. প্লে কনসোলের **Setup → API access** ট্যাবে গিয়ে গুগল ক্লাউড প্রজেক্টটি লিংক করুন।

### ধাপ ৪: IapService ক্লায়েন্ট কোড বাস্তবায়ন
`lib/core/services/iap_service.dart` ফাইলে কোড লিখুন:
```dart
class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  static const String premiumMonthly = 'premium_monthly';
  static const String enterpriseMonthly = 'enterprise_monthly';
  static const List<String> _productIds = [premiumMonthly, enterpriseMonthly];

  static const String _iapNamespace = 'b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32';

  @override
  void onInit() {
    super.onInit();
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate);
  }

  String deriveIapAccountToken(String userId) {
    return const Uuid().v5(_iapNamespace, userId); // deterministic UUIDv5 Buyer Token
  }

  Future<void> buySubscription(ProductDetails product, String userId) async {
    final String accountToken = deriveIapAccountToken(userId);
    
    final purchaseParam = GooglePlayPurchaseParam(
      productDetails: product,
      applicationUserName: accountToken, // পেমেন্ট ট্র্যাকিংয়ের জন্য Buyer Token ম্যাপ করা হচ্ছে
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased || 
          purchase.status == PurchaseStatus.restored) {
        _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        _iap.completePurchase(purchase); // ফেইলুর হলে কিউ থেকে সরাতে হবে
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.postData(
      '${ApiConstants.subscriptionBaseUrl}/google/verify',
      {
        'purchaseToken': purchase.verificationData.serverVerificationData,
        'productId': purchase.productID,
      },
    );

    if (response != null && response.statusCode == 200) {
      await _iap.completePurchase(purchase); // অত্যন্ত গুরুত্বপূর্ণ: এপিআই সাকসেস হলে কিউ ক্লোজ করতে হবে
    }
  }
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **ভেরিফিকেশন রাউট:** `POST /api/v1/subscriptions/google/verify`
*   **রিকোয়েস্ট বডি:**
    ```json
    {
      "purchaseToken": "cakmjihibdn...AO-J1Oz...",
      "productId": "premium_monthly"
    }
    ```
*   **ভেরিফিকেশন:** ব্যাকএন্ড সার্ভার এপিআই এর মাধ্যমে গুগলের `androidpublisher.subscriptions.get` মেথড কল করে পেমেন্ট যাচাই করবে এবং সাকসেস হলে ইউজারের সাবস্ক্রিপশন ডাটাবেজে আপডেট করবে।

---

# Testing Guide (টেস্টিং গাইড)

### লাইসেন্স টেস্টিং সেটিংস (License Testing)
1. Play Console-এর হোম পেজে যান → **Settings → License testing**।
2. আপনার টেস্টার জিমেইল অ্যাকাউন্টগুলো ইনপুট করুন।
3. **License response** অপশনটি `RESPOND_NORMALLY` সিলেক্ট করুন।
4. টেস্টার জিমেইল লগইন থাকা একটি রিয়েল অ্যান্ড্রয়েড ডিভাইসে অ্যাপটি রান করে সাবস্ক্রাইব করুন। পেমেন্ট শিট ওপেন হলে **"Test card, always approves"** ব্যানারটি দেখতে পাবেন।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| প্রোডাক্ট লিস্ট আসছে না (0 items) | প্রজেক্ট ক্লোজড ট্র্যাকে আপলোড করা হয়নি অথবা আইডি মেলেনি | অ্যাপ বান্ডেল ক্লোজড ট্র্যাকে আপলোড সম্পন্ন করুন এবং কোডের প্রোডাক্ট আইডিসমূহ চেক করুন। |
| `insufficient permissions` | সার্ভিস অ্যাকাউন্ট এপিআই পারমিশন কি-তে ভুল সেটিংস রয়েছে | প্লে কনসোলের ইউজার পারমিশনে গিয়ে সার্ভিস অ্যাকাউন্টের ফাইনান্সিয়াল ডাটা কি ইনেবল করুন এবং ক্লাউড কানেকশন ভেরিফাই করুন। |
| পেমেন্ট হওয়ার পর লুপ হচ্ছে | ক্লায়েন্ট কোডে `completePurchase()` কল করা হয়নি | সার্ভার ভেরিফাই শেষ করে রেসপন্স সাকসেস আসার পর অ্যাপে `_iap.completePurchase(purchase)` কল করা হয়েছে কিনা নিশ্চিত করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   নিশ্চিত করুন ব্যাকএন্ডে ব্যবহৃত সার্ভিস অ্যাকাউন্ট JSON কি ফাইলটি সম্পূর্ণ সুরক্ষিত আছে এবং কোনো গিট রিপোজিটরিতে পাবলিশ করা হয়নি।

---

# Troubleshooting (ডিবাগিং গাইড)
*   প্লে কনসোলে সার্ভিস পারমিশন যুক্ত করার পর অ্যাক্টিভেট হতে সর্বোচ্চ ৩০ মিনিট পর্যন্ত সময় লাগতে পারে।
*   বিলিং ফিচার এমুলেটরে কাজ করবে না, ডিবাগ করার জন্য রিয়েল অ্যান্ড্রয়েড ডিভাইস ক্যাবল দিয়ে কানেক্ট করে টেস্ট করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **Buyer Token (UUIDv5) কেন জেনারেট করা হয়?** এটি ইউজারের আসল আইডিটি ক্রিপ্টোগ্রাফিক অ্যালগরিদম দিয়ে হাইড করে একটি ইউনিক টোকেন জেনারেট করে যা গুগলের `obfuscatedAccountId` ফিল্ডে অ্যাসাইন করা হয়। এর ফলে কোনো থার্ড-পার্টি ইউজারের আইডি হ্যাক করতে পারে না।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `in_app_purchase` এবং `uuid` প্লাগইন ইম্পোর্ট করুন।
2. গুগল ক্লাউড ডেভ এপিআই সেটিংস প্লে কনসোলের সাথে সিঙ্ক করুন।
3. প্লে কনসোলে প্রিমিয়াম প্রোডাক্ট আইডিগুলো তৈরি করে সচল করুন।
4. ক্লায়েন্টে `IapService` কোড লিখে অপশন বিল্ডারে পেমেন্ট প্যারামিটার লিংক করুন।
5. সার্ভার সাইডে পেমেন্ট রিসিট যাচাই করার ভেরিফিকেশন লজিক মেকানিজম লিখে রান করুন।

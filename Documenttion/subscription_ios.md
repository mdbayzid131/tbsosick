# In-App Purchases & Subscriptions (iOS) Guide (আইওএস ইন-অ্যাপ পারচেস গাইড)

এই ফাইলে আইওএস অ্যাপল অ্যাপ স্টোর বিলিং (StoreKit 2) ব্যবহার করে সাবস্ক্রিপশন বাস্তবায়ন এবং ব্যাকএন্ড এপিআই ভেরিফিকেশন সেটআপ সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
SMRTSCRUB অ্যাপে আইওএস ব্যবহারকারীদের জন্য সাবস্ক্রিপশন এবং বিলিং সার্ভিস পরিচালনা করতে অ্যাপল অ্যাপ স্টোর ইন্টিগ্রেশন ব্যবহার করা হয়। অ্যাপটি স্টোরকিট ২ (StoreKit 2) এপিআই ব্যবহার করে অ্যাপল সার্ভার থেকে প্রোডাক্ট লিস্ট সংগ্রহ করে, নেটিভ পেমেন্ট শীট চালু করে এবং পেমেন্ট শেষে JWS ফরম্যাটে এনক্রিপ্ট করা ট্রানজেকশন টোকেন রিসিভ করে। এরপর এটি ব্যাকএন্ড এপিআই-তে পাঠানো হয় যা অ্যাপল রিসিট ভেরিফিকেশন গেটওয়ের মাধ্যমে যাচাই করে সেশন সচল করে।

---

# Architecture (আর্কিটেকচার)
```
[User] ──(আইওএস প্ল্যান সিলেক্ট করে)──> [IapService] ──> লোকাল UserId থেকে Buyer Token জেনারেট করে
                                                     │
                                                     ├──> নেটিভ অ্যাপল স্টোরকিট পেমেন্ট শীট ওপেন করে
                                                     ├──> অ্যাপল থেকে JWS ট্রানজেকশন স্ট্রিং রিসিভ করে
                                                     └──> [IapService._verifyPurchase()]
                                                              │
                                                              └──> POST /subscriptions/apple/verify
                                                                   │
                                                                   └──> ব্যাকএন্ড অ্যাপল রুট কী দিয়ে সিগনেচার যাচাই করে
                                                                        (ভ্যালিডিটি ডাটা ডাটাবেজে সেভ করে)
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/iap_service.dart` - আইওএস ট্রানজেকশন লিসেনার, রিস্টোর পেমেন্ট এবং ভেরিফিকেশন হ্যান্ডশেক করার ক্লাস ফাইল।
*   `lib/core/bindings/initial_binding.dart` - অ্যাপের গ্লোবাল বাইন্ডিং সেটিংস যেখানে আইএপি সার্ভিস ইনিশিয়ালাইজ করা হয়।
*   `lib/config/constants/api_constants.dart` - আইওএস ভেরিফিকেশন পাথ (`/subscriptions/apple/verify`) সংজ্ঞায়িত করার ফাইল।
*   `lib/presentation/screens/ProfilePage/controller/subscription_controller.dart` - ইউআই স্ক্রিনে প্রোডাক্ট প্রাইসিং ম্যাপ করার কন্ট্রোলার।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  in_app_purchase: ^3.1.13
  in_app_purchase_storekit: ^0.4.8+1
  uuid: ^4.5.2
  get: ^4.7.3
```
*   `in_app_purchase`: ফ্লাটার গ্লোবাল বিলিং এপিআই র্যাপার প্লাগইন।
*   `in_app_purchase_storekit`: আইওএস স্টোরকিট সার্ভিস ব্যবহারের অফিসিয়াল প্লাগইন।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (এফসিএম এবং আইওএস বিলিং আলাদা সেটিংস; এর জন্য কোনো Firebase কনফিগারেশনের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   **Apple Developer Portal:** পেইড মেম্বারশিপ ডেভেলপার অ্যাকাউন্ট প্রয়োজন। এর মাধ্যমে অ্যাপ স্টোর কানেক্ট প্যানেলে গিয়ে সাবস্ক্রিপশন প্রোডাক্ট আইডি তৈরি করা, এগ্রিমেন্টস সই করা এবং শেয়ার্ড সিক্রেট জেনারেট করা হয়।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Apple Shared Secret:** অ্যাপ স্টোর কানেক্ট থেকে জেনারেট করা প্রাইভেট কি, যা ব্যাকএন্ডে রিসিট বা জেএসওন টোকেন ভেরিফাই করার জন্য ব্যবহৃত হয়।
*   **IAP Namespace ID:** ডার্ট ক্লায়েন্ট সাইডে ইউজারের পরিচয় এনক্রিপ্ট করার জন্য কাস্টম Namespace আইডি।
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

### ধাপ ১: অ্যাপ স্টোর কানেক্টে প্রোডাক্ট ও সাবস্ক্রিপশন গ্রুপ তৈরি করা
1. [App Store Connect](https://appstoreconnect.apple.com/)-এ লগইন করুন।
2. আপনার App সিলেক্ট করে **Monetization → Subscriptions** সেকশনে যান।
3. একটি নতুন **Subscription Group** তৈরি করুন (যেমন: `SMRTSCRUB Subscriptions`)।
4. গ্রুপের ভেতরে প্রোডাক্ট আইডিগুলো তৈরি করুন (আইডিগুলো অবশ্যই কোডের প্রোডাক্ট আইডির সাথে হুবহু মিলতে হবে):

| Product ID | Reference Name | Duration | Status |
|---|---|---|---|
| `premium_monthly` | Premium Monthly | 1 Month | Ready to Submit |
| `premium_yearly` | Premium Yearly | 1 Year | Ready to Submit |
| `enterprise_monthly` | Enterprise Monthly | 1 Month | Ready to Submit |
| `enterprise_yearly` | Enterprise Yearly | 1 Year | Ready to Submit |

5. প্রোডাক্টগুলোর প্রাইস এবং ডেসক্রিপশন সেট করে সায়েন-ইন ক্যাটাগরি কনফার্ম করুন।

### ধাপ ২: স্যান্ডবক্স টেস্ট অ্যাকাউন্ট তৈরি করা
আইওএসে পেমেন্ট টেস্ট করার জন্য আলাদা স্যান্ডবক্স অ্যাকাউন্ট প্রয়োজন:
1. App Store Connect-এর **Users and Access → Sandbox → Testers**-এ যান।
2. **+** বাটনে ক্লিক করে নতুন টেস্টার ইমেল ও পাসওয়ার্ড দিয়ে অ্যাকাউন্ট তৈরি করুন।
3. আপনার ফিজিক্যাল আইফোনে **Settings → App Store**-এ যান।
4. স্ক্রল করে নিচে নামলে **Sandbox Account** অপশন পাবেন, সেখানে আপনার তৈরি করা স্যান্ডবক্স টেস্টার জিমেইল আইডি দিয়ে লগইন করুন।

### ধাপ ৩: রিস্টোর পারচেস কোড বাস্তবায়ন
অ্যাপল স্টোর গাইডলাইন অনুযায়ী আইএপি পেজে একটি "Restore Purchases" বাটন থাকা বাধ্যতামূলক। সার্ভিস ক্লাসে মেথডটি লিখুন:
```dart
Future<void> restorePurchases() async {
  try {
    await _iap.restorePurchases();
  } catch (e) {
    // এরর ট্র্যাক করুন
  }
}
```

### ধাপ ৪: আইওএস ভেরিফিকেশন এন্ডপয়েন্ট কল করা
অ্যাপল স্টোরকিট ২ থেকে প্রাপ্ত JWS পেমেন্ট রিসিট ব্যাকএন্ড এপিআই-তে পোস্ট করা:
```dart
Future<void> _verifyPurchase(PurchaseDetails purchase) async {
  if (Platform.isIOS) {
    final apiClient = Get.find<ApiClient>();
    final response = await apiClient.postData(
      '${ApiConstants.subscriptionBaseUrl}/apple/verify',
      {
        'signedTransactionInfo': purchase.verificationData.serverVerificationData, // JWS টোকেন
      },
    );

    if (response != null && response.statusCode == 200) {
      await _iap.completePurchase(purchase); // কিউ ক্লোজ করা হচ্ছে
    }
  }
}
```

### ধাপ ৫: TestFlight-এ বিল্ড আপলোড করা
আইওএস আর্কাইভ জেনারেট করতে রান করুন:
```bash
flutter clean && flutter pub get
flutter build ipa
```
Xcode ওপেন করে জেনারেট হওয়া ডিরেক্টরি আর্কাইভ বিল্ডটি অ্যাপ স্টোর কানেক্ট ড্যাশবোর্ডে ডিস্ট্রিবিউট করুন এবং TestFlight-এ টেস্টারদের অ্যাপ ডাউনলোড লিংক ইনভাইট করুন।

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **ভেরিফিকেশন রাউট:** `POST /api/v1/subscriptions/apple/verify`
*   **রিকোয়েস্ট বডি:**
    ```json
    {
      "signedTransactionInfo": "eyJhbGciOiJFUzI1NiIs..."
    }
    ```
*   **ভেরিফিকেশন:** ব্যাকএন্ড সার্ভার অ্যাপল ডিকোড লাইব্রেরি ব্যবহার করে JWS-এর সিগনেচার যাচাই করবে এবং রেসপন্স সাকসেস হলে ডাটাবেজে সাবস্ক্রিপশন মেয়াদ সিঙ্ক করবে।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: স্যান্ডবক্স সাবস্ক্রিপশন
*   **ধাপ:** সাবস্ক্রাইব বাটনে ক্লিক করুন, অ্যাপল স্যান্ডবক্স পারচেস প্যানেলে কনফার্ম করে স্যান্ডবক্স আইডি পাসওয়ার্ড দিন।
*   **প্রстановиত ফলাফল:** পেমেন্ট সম্পন্ন হবে, অ্যাপ জেনারেট করা JWS টোকেন সার্ভারে পাঠাবে এবং সার্ভার পেমেন্ট যাচাই করে ইউজার অ্যাকাউন্ট প্রিমিয়াম করবে।

### টেস্ট কেস ২: রিস্টোর পারচেস
*   **ধাপ:** অ্যাপটি রিয়েল ডিভাইস থেকে ডিলিট করে পুনরায় টেস্ট বিল্ড ডাউনলোড করুন এবং সাবস্ক্রিপশন স্ক্রিনের **Restore Purchases** বাটনে ক্লিক করুন।
*   **প্রত্যাশিত ফলাফল:** অ্যাপল স্টোর এপিআই থেকে আগের সচল সাবস্ক্রিপশন ট্রানজেকশন সফলভাবে রিসিভ হবে এবং ইউজার প্রিমিয়াম স্টেট ফিরে পাবেন।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| প্রোডাক্ট কোয়েরিতে এম্পটি লিস্ট আসছে | অ্যাপ স্টোর কানেক্টে ট্যাক্স ও ব্যাংকিং এগ্রিমেন্ট সাইন করা নেই | App Store Connect ড্যাশবোর্ডের Agreements, Tax, and Banking ট্যাবে গিয়ে Paid Apps এগ্রিমেন্ট সম্পূর্ণ করুন। |
| ভেরিফিকেশন এপিআই `401` রিটার্ন করছে | ব্যাকএন্ড ড্যাশবোর্ডে অ্যাপল শেয়ার্ড সিক্রেট কী মিসিং | App Store Connect সেটিংস থেকে App-Specific Shared Secret কী জেনারেট করে ব্যাকএন্ড এনভায়রনমেন্টে সেভ করুন। |
| স্যান্ডবক্স পেমেন্ট রিজেক্ট হচ্ছে | স্যান্ডবক্স আইডেন্টিটি আন-ভেরিফাইড | নতুন টেস্টার ইমেল তৈরি করে সেটিংস থেকে পুনরায় সাইন-ইন করে টেস্ট করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   Xcode রানার ক্যাপাবিলিটিসে গিয়ে **In-App Purchase** সেটিংস অন করা আছে কিনা নিশ্চিত হোন।
*   অ্যাপল ড্যাশবোর্ডে Paid Apps এগ্রিমেন্ট সচল আছে কিনা কনফার্ম করুন।

---

# Troubleshooting (ডিবাগিং গাইড)
*   আইওএস পেমেন্ট এবং রিস্টোর ফিচার সিমুলেটরে রান করবে না, টেস্ট করার জন্য ফিজিক্যাল আইফোন ডিভাইস ব্যবহার করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **স্টোরকিট ১ বনাম স্টোরকিট ২:** স্টোরকিট ২ সরাসরি JWS ফরমেটের টোকেন (`signedTransactionInfo`) পাঠায়। পুরাতন অ্যাপল রিসিট ভেরিফিকেশন (`verifyReceipt`) এপিআই অ্যাপল দ্বারা ডিপ্রিকেটেড করা হয়েছে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `in_app_purchase` লাইব্রেরি ডিপেনডেন্সিটি প্রজেক্টে যুক্ত করুন।
2. অ্যাপ স্টোর কানেক্ট প্যানেলে Paid Apps চুক্তিপত্র সম্পন্ন করুন।
3. প্রজেক্টের রুট সাবস্ক্রিপশন গ্রুপ ও চার ধরনের সাবস্ক্রিপশন আইডি তৈরি করুন।
4. ক্লায়েন্টে রিস্টোর পারচেস বাটন লজিক যুক্ত করুন।
5. ব্যাকএন্ডে অ্যাপল JWS ডিকোড করার জন্য ভেরিফিকেশন এপিআই সেটিংস সচল করুন।

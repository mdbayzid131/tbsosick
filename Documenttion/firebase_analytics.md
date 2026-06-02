# Firebase Analytics Integration Guide (অ্যানালিটিক্স গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে Firebase Analytics নতুন করে ইন্টিগ্রেশন করা, কাস্টম ইভেন্ট ট্র্যাক করা এবং স্ক্রিন ভিউ ট্র্যাকিং কনফিগার করার নিয়ম সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
Firebase Analytics অ্যাপের ব্যবহারকারীর আচরণ, স্ক্রিন ভিজিট কাউন্ট এবং প্রজেক্টের কাস্টম ইভেন্ট (যেমন: সাইন-আপ, পেমেন্ট অপশন ক্লিক, অর্ডার অ্যাকশন) ট্র্যাক করতে সাহায্য করে। এই গাইডলাইনটি অনুসরণ করে আপনি প্রজেক্টে গুগল অ্যানালিটিক্স সচল করতে পারবেন, কাস্টম ইউজার প্রোপার্টি সেট করতে পারবেন এবং রাউটার স্ক্রিন লিসেনার কনফিগার করতে পারবেন।

---

# Architecture (আর্কিটেকচার)
```
[User Action / Screen Change] ──> [Firebase Analytics SDK]
                                           │
                                           └──> ব্যাকগ্রাউন্ডে ইভেন্ট ডাটা বাঞ্চ (batch) করে
                                                └──> Firebase Analytics কনসোল ড্যাশবোর্ডে পাঠায়
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/main.dart` - অ্যাপ ইনিশিয়ালাইজেশনে Firebase লোড করার ফাইল।
*   `lib/core/services/analytics_service.dart` - কাস্টম লগ ইভেন্ট র্যাপার সার্ভিস ক্লাস (নতুন ফাইল)।

---

# Dependencies (ডিপেন্ডেন্সি)
আপনার `pubspec.yaml` ফাইলে ডিপেন্ডেন্সি যোগ করুন:
```yaml
dependencies:
  firebase_core: ^4.4.0
  firebase_analytics: ^11.2.0
```
*   `firebase_analytics`: গুগল অ্যানালিটিক্স ডাটা আদান-প্রদান করার অফিসিয়াল ফ্লাটার লাইব্রেরি।

---

# Firebase Configuration (Firebase কনফিগারেশন)
1. **Firebase Console** ওপেন করুন।
2. **Project Settings → General** ট্যাবে যান।
3. গুগল অ্যানালিটিক্স সেকশনে চেক করুন প্রজেক্টের সাথে গুগল অ্যানালিটিক্স অ্যাকাউন্ট লিংক করা আছে কিনা। লিংক করা না থাকলে অন-স্ক্রিন গাইডলাইন অনুসরণ করে নতুন অ্যাকাউন্ট লিংক করে নিন।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   **Google Analytics Account:** ড্যাশবোর্ডের গ্রাফ ডাটা চেক করতে, কনভার্সন ট্র্যাকিং সেট করতে এবং অডিয়েন্স ভিউ জেনারেট করতে অ্যাডমিন এক্সেস প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   গুগল অ্যানালিটিক্সের সিকিউরিটি কি আলাদা করে সেভ করতে হয় না। এটি অ্যাপের ডিফল্ট `google-services.json` ও `GoogleService-Info.plist` কনফিগারেশন ফাইল থেকে রিড হয়।

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

### ধাপ ১: প্যাকেজ ইনস্টল করা
টার্মিনালে কমান্ড রান করুন:
```bash
flutter pub add firebase_analytics
```

### ধাপ ২: অ্যানালিটিক্স হেল্পার সার্ভিস তৈরি করা
কাস্টম ইভেন্ট এবং ইউজার প্রোপার্টি ট্র্যাক করার জন্য [analytics_service.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/analytics_service.dart) ফাইল তৈরি করুন:
```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // রুট বা পেজ স্ক্রিন নেভিগেশন অটো ট্র্যাক করার জন্য গেটএক্স রাউট লিসেনার
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // সাইন-ইন ইভেন্ট ট্র্যাকিং
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // রেজিস্ট্রেশন ইভেন্ট ট্র্যাকিং
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // কাস্টম সাবস্ক্রিপশন ক্লিক ইভেন্ট
  Future<void> logPurchase(String planName, double price) async {
    await _analytics.logEvent(
      name: 'subscribe_click',
      parameters: {
        'plan_name': planName,
        'price': price,
      },
    );
  }

  // ক্রস-ডিভাইস ট্র্যাকিংয়ের জন্য কাস্টম ইউজার আইডি ম্যাপিং
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
```

### ধাপ ৩: গ্লোবাল বাইন্ডিং ও রাউটার অবজারভার সেটিংস
আপনার প্রজেক্টের [initial_binding.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/bindings/initial_binding.dart) ফাইলে সার্ভিসটি সচল করুন:
```dart
Get.put(AnalyticsService(), permanent: true);
```
পেজ ট্রানজেকশন ট্র্যাকিং অটোমেটিক সচল করতে [app.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/app.dart) ফাইলে রাউটার অবজারভার যুক্ত করুন:
```dart
GetMaterialApp(
  navigatorObservers: [
    Get.find<AnalyticsService>().observer, // পেজ স্ক্রিন ভিউ অটো ট্র্যাক করার লিসেনার
  ],
  initialRoute: AppRoutes.splash,
  getPages: pages,
);
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   Firebase Analytics ব্যবহারের জন্য ব্যাকএন্ডে কোনো আলাদা কনফিগারেশনের প্রয়োজন নেই।

---

# Testing Guide (টেস্টিং গাইড)

### রিয়েল-টাইম ইভেন্ট ট্র্যাকিং যাচাই (DebugView)
লাইভ ডিবাগ চেক করতে টার্মিনালে ডিবাগ ফ্ল্যাগ অন করুন:
*   **Android:**
    ```bash
    adb shell setprop debug.firebase.analytics.app com.tbsosick.smrtscrub
    ```
*   **iOS:** Xcode ওপেন করুন, **Product → Scheme → Edit Scheme**-এ যান। **Run → Arguments** সেকশনে ক্লিক করে Argument list-এ টাইপ করুন:
    ```text
    -FIRDebugEnabled
    ```
ডিভাইস রান করুন এবং Firebase Console-এর **Analytics → DebugView** ড্যাশবোর্ডে রিয়েল-টাইম ডাটা সিঙ্ক যাচাই করুন।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| DebugView ড্যাশবোর্ডে ডাটা শো করছে না | ডিবাগ ফ্ল্যাগ অন করা নেই | অ্যান্ড্রোয়েডে ADB কমান্ড রান করুন অথবা Xcode স্কিম আর্গুমেন্ট চেক করুন। |
| স্ক্রিন ভিউ সঠিক পেজ নেম শো করছে না | নেভিগেটর অবজারভার রুট সেটিংস করা নেই | MaterialApp রাউটারের `navigatorObservers` লুপ প্যানেলে সঠিক অবজারভার ফাইল ইনপুট চেক করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   রিলিজ বিল্ড কম্পাইল করার আগে গুগল অ্যানালিটিক্স প্রোভাইডার সেটিংস একটিভ আছে কিনা তা Firebase কনসোল থেকে নিশ্চিত হয়ে নিন।

---

# Troubleshooting (ডিবাগিং গাইড)
*   ডিফল্ট অ্যানালিটিক্স ড্যাশবোর্ড গ্রাফ ডাটা আপডেট হতে ২৪ ঘণ্টা পর্যন্ত সময় লাগতে পারে। ইনস্ট্যান্ট যাচাইয়ের জন্য সর্বদা DebugView ড্যাশবোর্ড ব্যবহার করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **GDPR প্রাইভেসি পলিসি:** ইউরোপীয় ইউনিয়ন বা কাস্টম টেরিটরিতে রিলিজ করার আগে ব্যবহারকারীর কাছ থেকে ট্র্যাকিং ডাটা সংগ্রহের জন্য কনসেন্ট (consent) স্ক্রিন সচল করা বাধ্যতামূলক।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `firebase_analytics` লাইব্রেরি যুক্ত করুন।
2. কাস্টম ইভেন্ট ট্র্যাকিং সার্ভিস ক্লাস ফাইলটি তৈরি করুন।
3. MaterialApp সেটিংসের ডিরেক্টরিতে রাউটার নেভিগেটর অবজারভার লিংক করুন।
4. অ্যাপের পেজ অ্যাকশন বাটন মেথডে কাস্টম `logEvent` ইভেন্টগুলো কল করুন।

# Deep Linking Integration Guide (ডিপ লিঙ্কিং গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে কাস্টম ইউআরএল স্কিম (Custom URL Schemes) এবং অ্যান্ড্রয়েড অ্যাপ লিংকস (Android App Links) ও আইওএস ইউনিভার্সাল লিংকস (Universal Links) বাস্তবায়নের নির্দেশিকা দেওয়া হয়েছে।

---

# Overview (পরিচিতি)
ডিপ লিঙ্কিং হল এমন একটি টেকনোলজি যা ব্যবহারকারীকে কোনো ওয়েবসাইটের নির্দিষ্ট লিংকে ক্লিক করলে ব্রাউজার ওপেন না করে সরাসরি মোবাইল অ্যাপের ওই সম্পর্কিত নির্দিষ্ট পেজে রিডাইরেক্ট করে দেয়। যেমন পাসওয়ার্ড রিসেট লিংক, রেফারেল লিংক বা নোটিফিকেশন লিংক ক্লিক করলে সরাসরি মোবাইল অ্যাপের ভিউ ওপেন করা।

---

# Architecture (আর্কিটেকচার)
```
[User taps link] ──> [Android/iOS OS]
                           │
                           ├──> ডোমেন বা কাস্টম স্কিম ম্যাচ করে
                           ├──> রুট পে-লোড নিয়ে অ্যাপ ওপেন করে
                           └──> [AppLinks SDK / uni_links]
                                     │
                                     └──> রুট পাথ ডিকোড করে নির্দিষ্ট পেজে নেভিগেট করায়
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `android/app/src/main/AndroidManifest.xml` - অ্যান্ড্রয়েড রিডাইরেক্ট কাস্টম স্কিম ও ডোমেন ইনটেন্ট ফিল্টার কনফিগারেশন ফাইল।
*   `ios/Runner/Info.plist` - আইওএস কাস্টম স্কিম সেটিংস ফাইল।
*   `lib/core/services/deeplink_service.dart` - অ্যাপ রানিং বা বন্ধ থাকা অবস্থায় আসা ডিপ লিংক স্ট্রিম ক্যাচ ও নেভিগেট করার ক্লাস ফাইল (নতুন ফাইল)।

---

# Dependencies (ডিপেন্ডেন্সি)
আপনার `pubspec.yaml` ফাইলে ডিপেন্ডেন্সি যোগ করুন:
```yaml
dependencies:
  app_links: ^6.0.0
  get: ^4.7.3
```
*   `app_links`: অ্যান্ড্রয়েড অ্যাপ লিংক এবং আইওএস ইউনিভার্সাল লিংক ইভেন্ট স্ট্রিম ক্যাচ করার আধুনিক ডার্ট প্যাকেজ।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (ডিপ লিঙ্কিং সচল করার জন্য বেসিক ফ্লাটার লেভেলে আলাদা Firebase সেটিংসের প্রয়োজন নেই, যদি না আপনি Firebase Dynamic Links ব্যবহার করেন)।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   **Web Domain Server:** আপনার ডোমেন রুট পাথে ফাইল হোস্ট করার জন্য একটি ক্লাউড ওয়েব সার্ভার প্রয়োজন। সেখানে সিকিউর ডোমেন প্রমাণ করতে অ্যান্ড্রয়েডের জন্য `assetlinks.json` এবং আইওএসের জন্য `apple-app-site-association` ফাইল হোস্ট করতে হবে।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Custom Scheme:** কাস্টম স্কিম প্রোটোকল (যেমন: `signinwithapple` বা `smrtscrub`)।
*   **Web Domain Host:** আপনার ভেরিফাইড ডোমেন ডেসক্রিপশন (যেমন: `app.smrtscrub.app`)।

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

### ধাপ ১: অ্যান্ড্রয়েড ম্যানিফেস্টে ইনটেন্ট ফিল্টার সেটিংস
[AndroidManifest.xml](file:///c:/Users/mdbay/StudioProjects/tbsosick/android/app/src/main/AndroidManifest.xml) ফাইলে `<activity>` ব্লকে ইনটেন্ট ফিল্টার যোগ করুন:
*   **Custom Schemes (যেমন: অ্যাপল সাইন-ইন রিডাইরেক্ট):**
    ```xml
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="signinwithapple" />
    </intent-filter>
    ```
*   **App Links (ডোমেন মালিকানা যাচাই):**
    ```xml
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="app.smrtscrub.app" />
    </intent-filter>
    ```

### ধাপ ২: আইওএস ইউআরএল স্কিম ও ডোমেন ভ্যালিডেশন
*   **Custom Schemes:** Xcode ওপেন করুন অথবা সরাসরি `ios/Runner/Info.plist` ফাইলে অ্যাড করুন:
    ```xml
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>customscheme</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>smrtscrub</string>
        </array>
      </dict>
    </array>
    ```
*   **Universal Links:** Xcode-এর **Signing & Capabilities → Associated Domains** অপশনে গিয়ে অ্যাড করুন:
    ```text
    applinks:app.smrtscrub.app
    ```

### ধাপ ৩: ডিপ লিংক সার্ভিস কোড বাস্তবায়ন
[deeplink_service.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/deeplink_service.dart) ক্লাস ফাইল তৈরি করুন:
```dart
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DeeplinkService extends GetxService {
  final _appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // অ্যাপ সম্পূর্ণ বন্ধ (cold start) থাকা অবস্থায় লিংকে ক্লিক করলে হ্যান্ডেল করা
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      // এরর লগ করুন
    }

    // অ্যাপ ব্যাকগ্রাউন্ডে থাকা অবস্থায় লিংকে ক্লিক করলে রিসিভ করার লিসেনার
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      // এরর লগ করুন
    });
  }

  void _handleDeepLink(Uri uri) {
    final String path = uri.path;
    final Map<String, String> params = uri.queryParameters;

    if (path.contains('/verify-email')) {
      final String? token = params['token'];
      if (token != null) {
        Get.toNamed('/verify-otp', arguments: {'token': token});
      }
    } else if (path.contains('/reset-password')) {
      final String? token = params['token'];
      if (token != null) {
        Get.toNamed('/reset-password', arguments: {'token': token});
      }
    }
  }
}
```

### ধাপ ৪: গ্লোবাল বাইন্ডিংয়ে রেজিস্টার করা
[initial_binding.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/bindings/initial_binding.dart) ফাইলে সার্ভিসটি সচল করুন:
```dart
Get.put(DeeplinkService(), permanent: true);
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
ডোমেন ও অ্যাপের সিকিউর সম্পর্ক প্রমাণ করতে সার্ভারের ডিরেক্টরিতে কনফিগারেশন ফাইল হোস্ট করতে হবে:
*   **Android (`.well-known/assetlinks.json`):** `https://app.smrtscrub.app/.well-known/assetlinks.json` পাথে হোস্ট করুন। ফাইলটি অ্যাপের রিলিজ SHA-256 কী ধারণ করবে:
    ```json
    [{
      "relation": ["delegate_permission/common.handle_all_urls"],
      "target": {
        "namespace": "android_app",
        "package_name": "com.tbsosick.smrtscrub",
        "sha256_cert_fingerprints": ["RELEASE_SHA_256_FINGERPRINT"]
      }
    }]
    ```
*   **iOS (`.well-known/apple-app-site-association`):** `https://app.smrtscrub.app/.well-known/apple-app-site-association` পাথে হোস্ট করুন (অবশ্যই `application/json` হেডারে রেসপন্স সার্ভ করতে হবে):
    ```json
    {
      "applinks": {
        "apps": [],
        "details": [
          {
            "appID": "TEAM_ID.com.tbsosick.smrtscrub",
            "paths": [ "*" ]
          }
        ]
      }
    }
    ```

---

# Testing Guide (টেস্টিং গাইড)

### টার্মিনাল এমুলেশন টেস্ট
*   **অ্যান্ড্রয়েড কাস্টম স্কিম টেস্ট:** টার্মিনালে ADB কমান্ড রান করুন:
    ```bash
    adb shell am start -W -a android.intent.action.VIEW -d "signinwithapple://test-callback" com.tbsosick.smrtscrub
    ```
*   **অ্যান্ড্রয়েড অ্যাপ লিংক টেস্ট (ডোমেন ইউআরএল):** রান করুন:
    ```bash
    adb shell am start -W -a android.intent.action.VIEW -d "https://app.smrtscrub.app/reset-password?token=XYZ" com.tbsosick.smrtscrub
    ```

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| লিংকে ক্লিক করলে ব্রাউজার ওপেন হয়, অ্যাপ নয় | ডোমেন ডিরেক্টরিতে ভেরিফিকেশন ফাইল হোস্ট করা নেই | সার্ভারে ডোমেনের অধীনে `.well-known` ফোল্ডারের ফাইল সেটিংস চেক করুন। |
| অ্যাপ ক্র্যাশ করছে | ডিপ লিংক সার্ভিস দেরিতে রান করা হয়েছে | `initial_binding.dart` ফাইলে গ্লোবাল বাইন্ডিংয়ে সবার আগে সার্ভিসটি পুট করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   নিশ্চিত করুন হোস্টিং সার্ভারে সঠিক ডোমেন সার্টিফিকেট (SSL) সচল আছে। এইচটিটিপি (HTTP) প্রোটোকল অ্যান্ড্রয়েড ও আইওএস রিজেক্ট করে দেয়।

---

# Troubleshooting (ডিবাগিং গাইড)
*   আইওএস ইউনিভার্সাল লিংকের ক্ষেত্রে ডেভেলপার অ্যাকাউন্টে Associated Domains ফিচার সচল করা আছে কিনা তা অ্যাপ আইডেন্টিফায়ারে গিয়ে চেক করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **অ্যাপ লিংক বনাম কাস্টম স্কিম:** অ্যাপ লিংকস (App Links) ডোমেন সিকিউরিটি দিয়ে ভেরিফাই হয়ে সরাসরি অ্যাপ ওপেন করে। কাস্টম স্কিম কোনো ভেরিফিকেশন ফাইল ছাড়াই কাজ করে কিন্তু একাধিক অ্যাপের একই স্কিম থাকলে অপশন শীট দেখাবে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `app_links` প্যাকেজটি ইম্পোর্ট করুন।
2. অ্যান্ড্রয়েড ম্যানিফেস্টে এবং আইওএস Xcode প্যানেলে Associated Domains বা কাস্টম স্কিম লিংক করুন।
3. ডোমেনের আন্ডারে সিকিউর `.well-known` রিডাইরেক্ট কনফিগারেশন ফাইল হোস্ট করুন।
4. `DeeplinkService` ফাইলটি তৈরি করে ডিকোড ও রাউটার নেভিগেশন সেটিংস কোড লিখুন।

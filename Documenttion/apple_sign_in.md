# Apple Sign-In Integration Guide (অ্যাপল সাইন-ইন গাইড)

এই ফাইলে অ্যান্ড্রয়েড এবং আইওএস প্ল্যাটফর্মে অ্যাপল সাইন-ইন (Apple Sign-in) কনফিগারেশন এবং নিরাপত্তা প্রোটোকল বাস্তবায়নের নির্দেশিকা দেওয়া হয়েছে।

---

# Overview (পরিচিতি)
অ্যাপল সাইন-ইন ব্যবহারকারীদের দ্রুত এবং নিরাপদ উপায়ে একটি নতুন সেশন শুরু করতে সাহায্য করে। আইওএস ডিভাইসে এটি নেটিভ প্যানেলের মাধ্যমে কাজ করে এবং অ্যান্ড্রয়েড ডিভাইসে এটি একটি সিকিউর ওয়েব ফ্লো ওপেন করে। ক্লায়েন্ট অ্যাপ অ্যাপলের অথেন্টিকেশন টোকেন (`identityToken`) সংগ্রহ করে এবং রিপ্লে রিকোয়েস্ট (replay attacks) আটকাতে ক্রিপ্টোগ্রাফিক ননস (Nonce) জেনারেট করে এপিআই সার্ভারে যাচাই করার জন্য পাঠায়।

---

# Architecture (আর্কিটেকচার)
```
[User] ──(Apple বাটনে ট্যাপ করে)──> [SignInWithApple SDK]
                                           │
                                           ├──> (iOS) নেটিভ ফেস-আইডি/পাসকোড শীট দেখায়
                                           ├──> (Android) সিকিউর ওয়েব পেজ ভিউ ওপেন করে
                                           ├──> সিকিউরিটি ননস (Nonce) হ্যাশ তৈরি করে
                                           └──> [AuthService.signInWithApple()]
                                                    │
                                                    └──> /auth/social-login এ পোস্ট রিকোয়েস্ট পাঠায়
                                                         (বডি: provider: 'apple', idToken, nonce, deviceToken)
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/auth_service.dart` - অ্যাপল অথেন্টিকেশন ট্রিগার এবং সার্ভার হ্যান্ডশেক করার ক্লাস।
*   `lib/core/utils/nonce_helper.dart` - ক্রিপ্টোগ্রাফিক ননস জেনারেশন এবং SHA-256 হ্যাশিং ক্লাস।
*   `lib/data/repositories/auth_repository.dart` - এপিআই কল করার রেপো ক্লাস।
*   `ios/Runner/Runner.entitlements` - আইওএস বিল্ডে অ্যাপল সাইন-ইন ক্যাভাবিলিটি রেজিস্টার করার সেটিংস ফাইল।
*   `android/app/src/main/AndroidManifest.xml` - অ্যান্ড্রয়েডে রিডাইরেক্ট ইউআরএল রিসিভ করার জন্য ইনটেন্ট ফিল্টার কনফিগারেশন ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  sign_in_with_apple: ^6.1.1
  crypto: ^3.0.3
  get: ^4.7.3
```
*   `sign_in_with_apple`: ফ্লাটার অ্যাপে অ্যাপল সাইন-ইন যুক্ত করার মূল লাইব্রেরি।
*   `crypto`: ননস স্ট্রিং হ্যাশ করার জন্য ব্যবহৃত ক্রিপ্টোগ্রাফি প্যাকেজ।

---

# Firebase Configuration (Firebase কনফিগারেশন)
1. **Firebase Console** ওপেন করুন।
2. **Authentication → Sign-in method** পেজে যান।
3. **Apple** প্রোভাইডারটি ইনেবল করুন এবং সেভ করুন।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Apple Developer Portal:** আইওএস সার্টিফিকেশন ডাউনলোড করতে, সার্ভিস আইডি (Service ID) রেজিস্টার করতে এবং রিডাইরেক্ট ডোমেন ম্যানেজ করতে পেড ডেভেলপার মেম্বারশিপ প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Team ID:** আপনার অ্যাপল ডেভেলপার টিমের আইডি।
*   **Key ID:** অ্যাপল সাইন-ইন কনফিগার করার সময় প্রাপ্ত প্রাইভেট কি-এর আইডি।
*   **Bundle ID:** আইওএস অ্যাপের রুট বান্ডেল আইডি (যেমন: `com.tbsosick.smrtscrub`)।
*   **Service ID:** অ্যান্ড্রয়েড রিডাইরেক্ট যাচাইয়ের জন্য অ্যাপল ডেভেলপার পোর্টালে তৈরি করা ইউনিক সার্ভিস আইডি।
    *   *Real Project Value:* `com.tbsosick.smrtscrub.service`
*   **Redirect URI:** অ্যান্ড্রয়েড ব্যবহারকারীদের সাইন-ইন শেষে অ্যাপে ফিরিয়ে আনার গেটওয়ে লিংক।
    *   *Real Project Value:* `https://jenice-unfearing-predictively.ngrok-free.dev/api/v1/auth/apple/callback`

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

### ধাপ ১: Xcode ক্যাপাবিলিটি সেটিংস (iOS)
1. Xcode দিয়ে আপনার ফ্লাটার আইওএস প্রজেক্টটি ওপেন করুন।
2. `Runner` প্রজেক্ট সেটিংস থেকে **Signing & Capabilities** ট্যাবে যান।
3. **+ Capability** বাটনে ক্লিক করে **Sign in with Apple** যুক্ত করুন।
এর ফলে প্রজেক্টে [Runner.entitlements](file:///c:/Users/mdbay/StudioProjects/tbsosick/ios/Runner/Runner.entitlements) ফাইলটি জেনারেট হবে:
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

### ধাপ ২: অ্যান্ড্রয়েড ম্যানিফেস্টে ইনটেন্ট ফিল্টার যোগ করা
অ্যান্ড্রয়েডে অ্যাপল সাইন-ইন শেষে রিডাইরেক্ট ডাটা রিসিভ করতে [AndroidManifest.xml](file:///c:/Users/mdbay/StudioProjects/tbsosick/android/app/src/main/AndroidManifest.xml) ফাইলে রিসিভার যুক্ত করুন:
```xml
<!-- For Apple Sign-In -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="signinwithapple" />
</intent-filter>
```

### ধাপ ৩: ননস হেল্পার তৈরি করা
[nonce_helper.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/utils/nonce_helper.dart) ফাইলে সিকিউর ননস ও হ্যাশিং কোড লিখুন:
```dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

String sha256OfString(String input) {
  final bytes = utf8.encode(input);
  return sha256.convert(bytes).toString();
}
```

### ধাপ ৪: অথেন্টিকেশন কোড বাস্তবায়ন
[auth_service.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/auth_service.dart) ফাইলে অ্যাপল সাইন-ইন মেথড যুক্ত করুন:
```dart
Future<Response?> signInWithApple() async {
  try {
    final rawNonce = generateNonce();
    final hashedNonce = sha256OfString(rawNonce); // অ্যাপলের জন্য SHA256 করা ননস

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
      webAuthenticationOptions: Platform.isAndroid
          ? WebAuthenticationOptions(
              clientId: 'com.tbsosick.smrtscrub.service',
              redirectUri: Uri.parse(
                'https://jenice-unfearing-predictively.ngrok-free.dev/api/v1/auth/apple/callback',
              ),
            )
          : null,
    );

    final idToken = credential.identityToken;
    if (idToken == null) return null;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final response = await _authRepo.socialLogin(
      provider: 'apple',
      idToken: idToken,
      nonce: rawNonce, // ব্যাকএন্ডে RAW ননস পাঠাতে হবে, হ্যাশ করাটি নয়
      deviceToken: fcmToken,
      platform: Platform.isIOS ? 'ios' : 'android',
    );

    await _handleAuthResponse(response);
    return response;
  } catch (e) {
    rethrow;
  }
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **এন্ডপয়েন্ট:** `POST /api/v1/auth/social-login`
*   **পে-লোড ফরম্যাট:**
    ```json
    {
      "provider": "apple",
      "idToken": "eyJhbGciOiJSUzI1NiIs...",
      "nonce": "raw_nonce_value",
      "deviceToken": "FCM_REGISTRATION_TOKEN",
      "platform": "ios"
    }
    ```
*   **ভেরিফিকেশন:** ব্যাকএন্ড সার্ভার অ্যাপলের পাবলিক সার্টিফিকেট রিকোয়েস্ট করে ডিকোড করা আইডেন্টিটি জেসন টোকেনের সিগনেচার যাচাই করবে। এরপর প্রাপ্ত `nonce` প্যারামিটারের SHA-256 হ্যাশ এবং ডিকোড করা টোকেনের ননস ফিল্ড মিলিয়ে দেখবে।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: অ্যান্ড্রয়েড অ্যাপল সাইন-ইন
*   **ধাপ:** অ্যান্ড্রয়েড ফোনে অ্যাপল বাটনে ক্লিক করুন, ব্রাউজার ওভারলে আসলে ইমেইল ও পাসওয়ার্ড দিয়ে লগইন করুন।
*   **প্রত্যাশিত ফলাফল:** সাইন-ইন সম্পন্ন হওয়ার পর ব্রাউজার শিট ক্লোজ হবে এবং অ্যাপে সেশন জেনারেট হয়ে হোম পেজ ওপেন হবে।

### টেস্ট কেস ২: আইওএস নেটিভ শীট ভেরিফিকেশন
*   **ধাপ:** আইওএস ডিভাইসে অ্যাপল সাইন-ইন বাটনে ক্লিক করুন।
*   **প্রত্যাশিত ফলাফল:** নেটিভ পাসকোড বা ফেসআইডি ভেরিফিকেশন ওপেন হবে এবং সফল পেমেন্ট/আইডেন্টিটি সেশন রিসিভ হবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `invalid_client` | সার্ভিস আইডি বা রিডাইরেক্ট ইউআরএল সেটিংস মেলেনি | অ্যাপল ডেভেলপার কনসোলে সার্ভিস আইডির ভেতর আপনার রিডাইরেক্ট গেটওয়ে ইউআরএলটি সঠিকভাবে লিংক করুন। |
| `Authorization failed: Nonce mismatch` | ব্যাকএন্ডে ভুল ননস কি পাঠানো হয়েছে | নিশ্চিত করুন কোডের এপিআই বডিতে `rawNonce` পাঠানো হয়েছে, `hashedNonce` নয়। |
| অ্যান্ড্রয়েডে পেজ লোড হচ্ছে না | `WebAuthenticationOptions` প্যারামিটারটি ওমিট করা হয়েছে | অ্যান্ড্রয়েডে রিডাইরেক্ট করার জন্য অবশ্যই `WebAuthenticationOptions` কনফিগার করুন। |

---

# Production Deployment (প্রোডাকশন ডেপ্লয়মেন্ট)
*   রিলিজ ভার্সন পাবলিশ করার আগে ngrok গেটওয়ে ইউআরএলটি সরিয়ে প্রোডাকশন এপিআই রিডাইরেক্ট ইউআরএল যুক্ত করতে হবে।
*   প্রোডাকশন ডোমেনটি অবশ্যই অ্যাপল ডেভেলপার কনসোলের সার্ভিস সেটিংস পেজে ভেরিফাই করে নিতে হবে।

---

# Troubleshooting (ডিবাগিং গাইড)
*   আইওএস সিমুলেটরে অ্যাপল সাইন-ইন অনেক সময় এরর দিতে পারে। টেস্ট করার জন্য ফিজিক্যাল আইওএস ডিভাইস ব্যবহার করা সবচেয়ে নিরাপদ।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **ননস (Nonce) কেন প্রয়োজন?** অ্যাপল প্রতিটি লগইনে সিকিউরিটি টোকেন এনক্রিপ্ট করার জন্য হ্যাশ চায়। ব্যাকএন্ডে রিকোয়েস্ট রিপ্লে রুখতে সার্ভার রিয়েল-টাইমে রিসিভ করা র-ননস জেনারেট করে অ্যাপলের ডিকোড করা ননসের সাথে তুলনা করে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `sign_in_with_apple` এবং `crypto` লাইব্রেরি যুক্ত করুন।
2. Xcode-এর Signing & Capabilities থেকে অ্যাপল সাইন-ইন সচল করুন।
3. অ্যান্ড্রয়েড ম্যানিফেস্টে রিডাইরেক্ট স্কিম ফিল্টার অ্যাড করুন।
4. `nonce_helper.dart` ফাইলটি প্রজেক্টে কপি করে ব্যবহার করুন।
5. অথেন্টিকেশন সার্ভিসে প্রজেক্টের সার্ভিস আইডি এবং সঠিক গেটওয়ে ইউআরএল সেট করে কল মেথড লিখুন।

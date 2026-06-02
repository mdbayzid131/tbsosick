# Firebase Setup Guide (Firebase সেটআপ গাইড)

এই ফাইলে একটি ফ্লাটার মোবাইল অ্যাপ্লিকেশনের সাথে Firebase প্রজেক্ট কানেক্ট করার নিয়ম এবং অ্যান্ড্রয়েড ও আইওএস প্ল্যাটফর্মের কনফিগারেশন সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
Firebase অ্যাপের ব্যাকগ্রাউন্ড সার্ভিস হিসেবে পুশ নোটিফিকেশন (FCM), অথেন্টিকেশন, অ্যানালিটিক্স, ক্র্যাশ রিপোর্টিং এবং অন্যান্য ক্লাউড ফিচার প্রদান করে। এই ডকুমেন্টে প্ল্যাটফর্ম সেটিংস, ক্রেডেন্সিয়াল ম্যাপিং এবং অ্যাপের ভেতর Firebase ইনিশিয়ালাইজ করার ধাপগুলো ব্যাখ্যা করা হয়েছে।

---

# Architecture (আর্কিটেকচার)
ফ্লাটার ক্লায়েন্ট রান-টাইমে প্ল্যাটফর্ম-নির্দিষ্ট কনফিগারেশন সেটিংস ব্যবহার করে Firebase SDK ইনিশিয়ালাইজ করে। এটি নোটিফিকেশন এবং সোশ্যাল লগইন হ্যান্ডেল করতে সরাসরি Firebase সার্ভারের সাথে কানেক্ট হয়।

```
[Flutter App] ──(firebase_options.dart পড়ে)──> Firebase SDK ইনিশিয়ালাইজ করে
      │
      ├── (Android) ──> google-services.json লোড করে এবং SHA-1 কী চেক করে
      └── (iOS) ──> GoogleService-Info.plist লোড করে এবং Bundle ID চেক করে
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/main.dart` - অ্যাপের এন্ট্রি পয়েন্ট যেখানে `Firebase.initializeApp()` কল করা হয়।
*   `lib/firebase_options.dart` - অটো-জেনারেটেড কনফিগারেশন যা প্রতিটি প্ল্যাটফর্মের জন্য API Key এবং Project ID ধারণ করে।
*   `android/app/google-services.json` - অ্যান্ড্রয়েডের জন্য গুগল সার্ভিস কনফিগারেশন ফাইল।
*   `android/app/build.gradle.kts` - অ্যান্ড্রয়েড অ্যাপ গ্রেডেল ফাইল যা গুগল সার্ভিস ক্লাসপাথ ব্যবহার করে।
*   `android/build.gradle.kts` - রুট গ্রেডেল ফাইল যেখানে গুগল সার্ভিস প্লাগইন ইম্পোর্ট করা হয়।
*   `ios/Runner/GoogleService-Info.plist` - আইওএস কনফিগারেশন প্রপার্টি লিস্ট ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
আপনার `pubspec.yaml` ফাইলে নিচের ডিপেন্ডেন্সিটি যোগ করুন:
```yaml
dependencies:
  firebase_core: ^4.4.0
```
*   `firebase_core`: ফ্লাটার অ্যাপে Firebase যুক্ত করার জন্য এই প্যাকেজটি বাধ্যতামূলক।

---

# Firebase Configuration (Firebase কনফিগারেশন)

### ১. প্রজেক্ট তৈরি (Project Creation)
1. [Firebase Console](https://console.firebase.google.com/)-এ যান।
2. **Add project** বাটনে ক্লিক করে প্রজেক্টের নাম দিন (যেমন: `tbsosick-smrtscrub`)।
3. গুগল অ্যানালিটিক্স অপশনটি অন বা অফ করুন (ডিফল্টভাবে অন থাকে)।
4. **Create project**-এ ক্লিক করে প্রজেক্ট প্রোভিশন শেষ হওয়া পর্যন্ত অপেক্ষা করুন।

### ২. অ্যান্ড্রয়েড কনফিগারেশন (Android Configuration)
1. Firebase প্রজেক্ট ড্যাশবোর্ডে **Android icon**-এ ক্লিক করে অ্যাপ যুক্ত করুন।
2. **Android package name** দিন (এটি অবশ্যই `android/app/build.gradle.kts` ফাইলের `applicationId`-এর সাথে মিলতে হবে, যেমন: `com.tbsosick.smrtscrub`)।
3. আপনার **Debug SHA-1 fingerprint** পেস্ট করুন (Credentials সেকশনটি দেখুন)।
4. **Register app**-এ ক্লিক করে `google-services.json` ফাইলটি ডাউনলোড করুন।
5. ডাউনলোড করা ফাইলটি প্রজেক্টের `android/app/` ডিরেক্টরিতে পেস্ট করুন।

### ৩. আইওএস কনফিগারেশন (iOS Configuration)
1. ড্যাশবোর্ডে **Add app**-এ ক্লিক করে **iOS icon** সিলেক্ট করুন।
2. **iOS Bundle ID** প্রদান করুন (এটি অবশ্যই Xcode Bundle Identifier-এর সাথে হুবহু মিলতে হবে, যেমন: `com.tbsosick.smrtscrub`)।
3. **Register app**-এ ক্লিক করে `GoogleService-Info.plist` ফাইলটি ডাউনলোড করুন।
4. Xcode দিয়ে প্রজেক্ট ওপেন করে `GoogleService-Info.plist` ফাইলটি ড্র্যাগ করে `Runner` ফোল্ডারের ভেতর ছেড়ে দিন। নিশ্চিত করুন যে "Copy items if needed" চেক করা আছে।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Google Developer Account:** গুগল প্লে স্টোরে রিলিজ ট্র্যাকিং এবং রিলিজ SHA কী সিঙ্ক করার জন্য প্রয়োজন।
*   **Apple Developer Account:** আইওএস নোটিফিকেশন পুশ করার জন্য APNs কি জেনারেট করতে এবং অ্যাপল স্টোরে অ্যাপ সাবমিট করতে প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)

### SHA Keys জেনারেশন (Android-এর জন্য)
Firebase কনফিগারেশনে যুক্ত করার জন্য SHA-1 এবং SHA-256 কী জেনারেট করার নিয়ম:

*   **Debug Key:** টার্মিনালে নিচের কমান্ডটি রান করুন:
    ```powershell
    keytool -list -v -keystore C:\Users\YOUR_NAME\.android\debug.keystore -alias androiddebugkey -storepass android
    ```
*   **Release Key:** আপনার রিলিজ কী-স্টোর ফাইল ব্যবহার করে কমান্ডটি রান করুন:
    ```powershell
    keytool -list -v -keystore path/to/upload-keystore.jks -alias YOUR_ALIAS
    ```

### ক্রেডেন্সিয়াল ফাইল সংরক্ষণ
*   `google-services.json` ফাইলটি [android/app/google-services.json](file:///c:/Users/mdbay/StudioProjects/tbsosick/android/app/google-services.json) পাথে সেভ থাকে।
*   `GoogleService-Info.plist` ফাইলটি [ios/Runner/GoogleService-Info.plist](file:///c:/Users/mdbay/StudioProjects/tbsosick/ios/Runner/GoogleService-Info.plist) পাথে সেভ থাকে।
*   এই ফাইলগুলোতে পাবলিক এপিআই মেটাডাটা থাকে যা বিল্ড টাইমে কম্পাইল হয়ে যায়।

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

### ধাপ ১: Firebase CLI ইনস্টল করা
পিসিতে Firebase CLI ইনস্টল করে লগইন করুন:
```bash
npm install -g firebase-tools
firebase login
```

### ধাপ ২: FlutterFire কনফিগার করা
টার্মিনালে FlutterFire CLI সচল করে রান করুন:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
কমান্ডটি রান করার পর লিস্ট থেকে আপনার Firebase প্রজেক্টটি সিলেক্ট করুন এবং অ্যান্ড্রয়েড ও আইওএস প্ল্যাটফর্ম সিলেক্ট করে প্রজেক্ট আইডি লিংক করুন। এর ফলে `lib/firebase_options.dart` অটো-জেনারেট হয়ে যাবে।

### ধাপ ৩: অ্যান্ড্রয়েড গ্রেডেল সেটিংস আপডেট করা
*   **android/build.gradle.kts (Root):**
    ```kotlin
    plugins {
        id("com.google.gms.google-services") version "4.4.4" apply false
    }
    ```
*   **android/app/build.gradle.kts:**
    ```kotlin
    plugins {
        id("com.android.application")
        id("org.jetbrains.kotlin.android")
        id("dev.flutter.flutter-gradle-plugin")
        id("com.google.gms.google-services") // এই প্লাগইনটি অবশ্যই যুক্ত থাকতে হবে
    }
    ```

### ধাপ ৪: অ্যাপ ইনিশিয়ালাইজ করা
`lib/main.dart` ফাইলে Firebase SDK ইনিশিয়ালাইজ করুন:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tbsosick/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   প্রাথমিক Firebase সেটআপের জন্য ব্যাকএন্ডে কোনো আলাদা কনফিগারেশন প্রয়োজন হয় না। (পুশ নোটিফিকেশন এবং সোশ্যাল লগইনের জন্য প্রয়োজনীয় সেটিংস তাদের নিজস্ব ডকুমেন্টে ব্যাখ্যা করা হয়েছে)।

---

# Testing Guide (টেস্টিং গাইড)
1. অ্যাপটি একটি রিয়েল ডিভাইসে রান করুন।
2. কনসোল লগ চেক করে নিশ্চিত হোন যে `"Firebase initialized"` মেসেজটি প্রিন্ট হয়েছে এবং কোনো `FirebaseException` এরর আসেনি।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `Unable to find google-services.json` | কনফিগারেশন ফাইলটি সঠিক ডিরেক্টরিতে নেই | কনসোল থেকে ডাউনলোড করে ফাইলটি `android/app/` ফোল্ডারে রাখুন। |
| `Firebase has already been initialized` | `initializeApp` মেথডটি দুইবার কল হয়েছে | কোড থেকে অতিরিক্ত ডুপ্লিকেট ইনিশিয়ালাইজ মেথডটি সরিয়ে ফেলুন। |
| `Missing GoogleService-Info.plist` | আইওএস টার্গেট ফাইলটি খুঁজে পাচ্ছে না | Xcode প্রজেক্ট স্ট্রাকচার ব্যবহার করে ড্র্যাগ-অ্যান্ড-ড্রপ করে plist ফাইলটি যুক্ত করুন। |

---

# Production Deployment (প্রোডাকশন ডেপ্লয়মেন্ট)
*   লাইভ বা রিলিজ প্রজেক্ট পাবলিশ করার আগে কি-স্টোরের (Keystore) রিলিজ SHA-1 এবং SHA-256 কী দুটি Firebase কনসোলের অ্যাপ সেটিংসে যুক্ত করতে ভুলবেন না।
*   প্রোডাকশন বিল্ড কম্পাইল করার আগে নতুন কনফিগারেশন ফাইলগুলো পুনরায় ডাউনলোড করে প্রজেক্ট ফোল্ডারে সেট করে নিন।

---

# Troubleshooting (অ্যাডভান্সড ডিবাগিং)
*   লোকাল ক্যাশ মেমরি ডিলিট করতে টার্মিনালে `flutter clean` রান করুন।
*   নিশ্চিত হোন যে অ্যাপের প্যাকেজ আইডি এবং Firebase কনসোলে যুক্ত করা প্যাকেজ আইডি হুবহু এক (কেস-সেন্সিটিভ)।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   ভবিষ্যতে যদি নতুন কোনো প্ল্যাটফর্ম (যেমন: macOS বা Web) অ্যাড করা হয় অথবা কনসোলে সেটিংস আপডেট করা হয়, তবে পুনরায় `flutterfire configure` রান করতে হবে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. Firebase কনসোলে নতুন একটি প্রজেক্ট তৈরি করুন।
2. আপনার ফ্লাটার অ্যাপ থেকে প্যাকেজ নেম ও আইওএস বান্ডেল আইডি কালেক্ট করুন।
3. CLI টুলের মাধ্যমে `flutterfire configure` রান করে অপশন ফাইল জেনারেট করুন।
4. অ্যান্ড্রয়েড অ্যাপের গ্রেডেল ফাইলে গুগল সার্ভিস প্লাগইন ইম্পোর্ট করুন।
5. Xcode রানার ডিরেক্টরির ভেতর iOS plist ফাইলটি লিংক করুন।
6. অ্যাপের `main()` ফাংশনের শুরুতে core SDK ইনিশিয়ালাইজ করুন।

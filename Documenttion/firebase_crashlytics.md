# Firebase Crashlytics Integration Guide (ক্র্যাশলিটিক্স গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে Firebase Crashlytics নতুন করে ইন্টিগ্রেশন করা, লোকাল রান-টাইম এক্সেপশন ও ক্র্যাশ ট্র্যাক করা এবং ডিবাগ সেটিংস র্যাপ করার নিয়ম সম্পর্কে আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
Firebase Crashlytics একটি রিয়েল-টাইম ক্র্যাশ রিপোর্টার যা অ্যাপের স্টেবিলিটি বা পারফরম্যান্স নষ্টকারী সমস্যাগুলো শনাক্ত ও সমাধান করতে সাহায্য করে। SMRTSCRUB অ্যাপে সিস্টেম ক্র্যাশ, সিনট্যাক্স এরর, আন-হ্যান্ডেলড এক্সেপশন এবং ব্যাকএন্ড রিলেটেড এরর ট্র্যাকিং করে রিপোর্ট ড্যাশবোর্ডে স্ট্যাক ট্রেস সহ সেন্ড করার জন্য Crashlytics ব্যবহার করা হয়।

---

# Architecture (আর্কিটেকচার)
```
[Uncaught Isolate / UI Build Exceptions] ──> [Global Error Catch Blocks (main.dart)]
                                                      │
                                                      └──> [FirebaseCrashlytics SDK]
                                                                │
                                                                └──> এরর পে-লোড লোকালি স্টোর করে
                                                                     └──> পরবর্তী অ্যাপ রিস্টার্টে সার্ভারে সেন্ড করে
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/main.dart` - মেইন এন্ট্রি ফ্লাটার ফাইল যেখানে গ্লোবাল এরর উইজেট ক্যাচ মেকানিজম কনফিগার করা হয়।
*   `android/build.gradle.kts` - অ্যান্ড্রয়েড রুট বিল্ড ফাইল।
*   `android/app/build.gradle.kts` - অ্যান্ড্রয়েড অ্যাপ সোর্স বিল্ড সেটিংস ফাইল।
*   `ios/Runner` - Xcode রানার ফাইল যেখানে dSYM স্ক্রিপ্ট ইন্টিগ্রেশন জেনারেট করা হয়।

---

# Dependencies (ডিপেন্ডেন্সি)
আপনার `pubspec.yaml` ফাইলে ডিপেন্ডেন্সি যোগ করুন:
```yaml
dependencies:
  firebase_core: ^4.4.0
  firebase_crashlytics: ^4.2.0
```
*   `firebase_crashlytics`: ফ্লাটার ও নেটিভ কোড থেকে এরর লগ ক্যাপচার করে ক্লাউডে পাঠানোর মূল প্লাগইন।

---

# Firebase Configuration (Firebase কনফিগারেশন)
1. **Firebase Console** ওপেন করুন।
2. **Release & Monitor → Crashlytics** মেনুতে যান।
3. **Enable Crashlytics** বাটনে ক্লিক করুন।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   ক্র্যাশলিটিক্স কনফিগারেশনের জন্য আলাদা কোনো অ্যাকাউন্ট প্রয়োজন নেই।

---

# Credentials (ক্রেডেন্সিয়াল)
*   ক্র্যাশলিটিক্স সেটিংস সচল করতে আলাদা কোনো সিকিউরিটি কি-র প্রয়োজন নেই। এটি প্রজেক্টের রুট সেটিংস `google-services.json` ও `GoogleService-Info.plist` ফাইল থেকে রিড হয়।

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

### ধাপ ১: প্লাগইন ইনস্টল করা
টার্মিনালে রান করুন:
```bash
flutter pub add firebase_crashlytics
```

### ধাপ ২: অ্যান্ড্রয়েড গ্রেডেল প্লাগইন আপডেট
*   **android/build.gradle.kts (Root):**
    ```kotlin
    plugins {
        id("com.google.gms.google-services") version "4.4.4" apply false
        id("com.google.firebase.crashlytics") version "3.0.2" apply false // ক্র্যাশলিটিক্স রুট ডিপেন্ডেন্সি
    }
    ```
*   **android/app/build.gradle.kts:**
    ```kotlin
    plugins {
        id("com.android.application")
        id("org.jetbrains.kotlin.android")
        id("dev.flutter.flutter-gradle-plugin")
        id("com.google.gms.google-services")
        id("com.google.firebase.crashlytics") // অ্যান্ড্রয়েড অ্যাপ প্লাগইন অ্যাপ্লাই করা হচ্ছে
    }
    ```

### ধাপ ৩: Xcode বিল্ড ফেইজ কনফিগার করা (iOS)
আইওএস বিল্ড ক্র্যাশ ডিসিফার (Line numbering resolution) করার জন্য dSYM ফাইল আপলোড করতে হবে:
1. Xcode দিয়ে `ios/Runner.xcworkspace` ওপেন করুন।
2. `Runner` সেটিংস থেকে **Build Phases** ট্যাবে যান।
3. **+** আইকনে ক্লিক করে **New Run Script Phase** সিলেক্ট করুন।
4. স্ক্রিপ্ট বডিতে রান স্ক্রিপ্ট পাথ দিন:
   ```bash
   "${PODS_ROOT}/FirebaseCrashlytics/run"
   ```
5. **Input Files** সেকশনে ক্লিক করে ডিরেক্টরি পাথ দিন:
   ```text
   $(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)
   ```

### ধাপ ৪: main.dart ফাইলে গ্লোবাল ক্যাচ সেটিংস কনফিগার করা
[main.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/main.dart) ফাইলে গ্লোবাল ফ্রেমওয়ার্ক ও মেমরি এক্সেপশন এরর ট্র্যাকিং লুপ বসান:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ফ্লাটার ফ্রেমওয়ার্ক থ্রেড এক্সেপশন এরর ট্র্যাকিং
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // ডার্ট রান-টাইম আইসোলেট এক্সেপশন ট্র্যাকিং (Async errors)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   ক্র্যাশলিটিক্স ক্লায়েন্ট ট্র্যাকিংয়ের জন্য ব্যাকএন্ডে কোনো আলাদা কনফিগারেশনের প্রয়োজন নেই।

---

# Testing Guide (টেস্টিং গাইড)

### ক্র্যাশ রিপোর্টিং যাচাই করা (Force Crash)
1. অ্যাপের যেকোনো স্ক্রিনে টেস্ট করার জন্য একটি ডামি বাটন তৈরি করুন:
   ```dart
   ElevatedButton(
     onPressed: () => FirebaseCrashlytics.instance.crash(), // ফোর্স ক্র্যাশ ট্রিপার করা হচ্ছে
     child: const Text("Force Crash"),
   )
   ```
2. অ্যাপটি রিলিজ মোডে রান করুন (ডিবাগ মোডে ক্র্যাশলিটিক্স ডাটা আপলোড হয় না)।
3. বাটনটিতে ক্লিক করে অ্যাপটি ক্র্যাশ করান।
4. অ্যাপটি পুনরায় ওপেন করুন (অ্যাপটি স্টার্ট হওয়ার পর লোকাল মেমরিতে থাকা ক্র্যাশ রিপোর্টটি সার্ভারে আপলোড করে)।
5. **Firebase Console → Crashlytics** ড্যাশবোর্ডে গিয়ে ক্র্যাশ স্ট্যাক ট্রেস লোড হয়েছে কিনা তা চেক করুন।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| ড্যাশবোর্ডে কোনো ক্র্যাশ ডাটা শো করছে না | অ্যাপটি ডিবাগ মোডে রান করা হয়েছে | রিলিজ মোডে টেস্ট রান করুন এবং ডিভাইস রিস্টার্ট সেটিংস ভেরিফাই করুন। |
| ক্র্যাশ ড্যাশবোর্ডে লাইন নম্বর শো করছে না | Xcode dSYM জেনারেট স্ক্রিপ্ট এড করা নেই | Xcode Build Phases-এ ক্র্যাশলিটিক্স স্ক্রিপ্ট পাথ এড করা আছে কিনা কনফর্যম করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   নিশ্চিত করুন প্রোডাকশন বিল্ড জেনারেট করার আগে ডামি ফোর্স ক্র্যাশ বাটনটি সোর্স কোড থেকে মুছে ফেলা হয়েছে।
*   প্রয়োজনে ডাইনামিক রিয়েল-টাইম এরর কন্ট্রোল ক্যাচিং ইনেবল রাখুন।

---

# Troubleshooting (ডিবাগিং গাইড)
*   অ্যান্ড্রয়েডে ক্র্যাশ ডাটা না আসলে গুগল প্লে সার্ভিস সেটিংস আপডেট করুন।
*   আইওএসে অ্যাপ ডিস্ট্রিবিউট করার সময় Xcode আর্কাইভ সম্পন্ন করার পর dSYM সিঙ্ক সম্পন্ন হতে কিছুক্ষণ সময় নিতে পারে।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **recordError বনাম recordFlutterFatalError:** ইউআই বিল্ডার বা অ্যাপ রেন্ডারিং ট্র্যাকিংয়ের জন্য `recordFlutterFatalError` কল করা হয়। অন্যান্য ডাইনামিক বা এপিআই রেসপন্স ট্রাই-ক্যাচ ট্র্যাকিংয়ের জন্য `recordError` ব্যবহার করা সুবিধাজনক।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `firebase_crashlytics` প্যাকেজ যুক্ত করুন।
2. অ্যান্ড্রয়েড বিল্ড ফাইলগুলোতে ক্র্যাশলিটিক্স প্লাগইন প্রয়োগ করুন।
3. Xcode রান স্কিপ্ট ফেইজে `run` স্ক্রিপ্ট পাথটি পেস্ট করুন।
4. `main.dart` ফাইলে `FlutterError.onError` ও `PlatformDispatcher.instance.onError` মেথড ডিফাইন করুন।
5. রিলিজ বিল্ডে ফোর্স ক্র্যাশ বাটন দিয়ে ডাটা সিঙ্ক যাচাই করুন।

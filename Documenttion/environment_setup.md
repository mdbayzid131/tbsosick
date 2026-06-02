# Environment Setup Guide (এনভায়রনমেন্ট সেটিংস গাইড)

এই ফাইলে SMRTSCRUB মোবাইল অ্যাপ্লিকেশনের লোকাল ডেভেলপার ওয়ার্কস্পেস সেটআপ, প্যাকেজ ডিপেন্ডেন্সি সচল করা এবং কোড জেনারেশন কমান্ড রান করার নিয়ম সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
SMRTSCRUB হল একটি ফ্লাটার প্রজেক্ট যা অ্যান্ড্রয়েড ও আইওএস প্ল্যাটফর্মকে টার্গেট করে তৈরি। লোকাল কম্পিউটারে প্রজেক্টটি রান ও ডেভেলপ করতে হলে ফ্লাটার এসডিকে (Flutter SDK) ইনস্টল করতে হবে, আইডিই (IDE) কনফিগার করতে হবে, এপিআই বেস পাথ লিংক করতে হবে এবং ডার্ট জেনারেটর প্লাগইন রান করতে হবে।

---

# Architecture (আর্কিটেকচার)
```
[Developer Machine] ──> [Flutter SDK + Android Studio / Xcode]
                              │
                              ├──> pubspec.yaml থেকে প্যাকেজগুলো ডাউনলোড করে
                              ├──> api_constants.dart ফাইলে এপিআই ইউআরএল সেট করে
                              └──> সোর্স ফাইল রান ও বিল্ড রানার জেনারেট করে
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `pubspec.yaml` - অ্যাপের থার্ড পার্টি লাইব্রেরি, ফন্ট সেটিংস ও লোগো অ্যাসেট সংজ্ঞায়িত করার ফাইল।
*   `lib/config/constants/api_constants.dart` - ডেভেলপমেন্ট, স্টেজিং ও প্রোডাকশন এপিআই ইউআরএল সেভ করার ফাইল।
*   `android/app/build.gradle.kts` - অ্যান্ড্রয়েড SDK কম্পাইলার ভার্সন ও প্যাকেজ সেটিংস ফাইল।
*   `ios/Podfile` - আইওএস নেটিভ ডিপেন্ডেন্সি (CocoaPods) হ্যান্ডেল করার সেটিংস ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
### ডেভেলপমেন্ট পিসি সেটিংস
*   **Flutter SDK:** ভার্সন `^3.10.4` (ডার্ট SDK `^3.0.0`)।
*   **Android Studio:** অ্যান্ড্রয়েড কম্পাইল সেটিংস এবং অ্যান্ড্রয়েড এমুলেটর রান করতে প্রয়োজন।
*   **Xcode:** (শুধুমাত্র ম্যাকওএস ডিভাইসে) আইওএস রিলিজ প্যাকেজ এবং আইওএস সিমুলেটর রান করতে প্রয়োজন।
*   **CocoaPods:** আইওএসের থার্ড পার্টি লাইব্রেরি লিঙ্ক করতে প্রজেক্টে প্রয়োজন।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (প্রাথমিক লোকাল এনভায়রনমেন্ট সেটআপের জন্য আলাদা কোনো Firebase সেটিংসের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   **Google Developer Account:** গুগল প্লে স্টোরে রিলিজ বান্ডেল আপলোড করতে প্রয়োজন।
*   **Apple Developer Account:** আইওএস লাইসেন্স কী ডাউনলোড করতে এবং টেস্টফ্লাইট সচল করতে প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Keystore File:** অ্যান্ড্রয়েড রিলিজ সাইন ইন করার সার্টিফিকেট ফাইল (`upload-keystore.jks`)।
*   **API Base URL Constants:** [api_constants.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/config/constants/api_constants.dart) ফাইলের ভেতর সচল এপিআই ইউআরএল:
    *   *Production API:* `https://api.smrtscrub.app/api/v1`
    *   *Staging API:* `https://nayem5001.binarybards.online/api/v1`

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

### ধাপ ১: প্রজেক্ট ক্লোন করা ও প্যাকেজ ডাউনলোড
টার্মিনালে কমান্ডগুলো রান করুন:
```bash
flutter doctor
flutter pub get
```

### ধাপ ২: এপিআই এন্ডপয়েন্ট সিলেক্ট করা
[api_constants.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/config/constants/api_constants.dart) ফাইলটি ওপেন করুন। আপনার বর্তমান ডেভেলপমেন্ট এনভায়রনমেন্ট অনুযায়ী লাইভ বা স্ট্যাজিং ইউআরএলটি আন-কমেন্ট করুন:
```dart
class ApiConstants {
  // লাইভ প্রোডাকশন ইউআরএল
  static const String baseUrl = 'https://api.smrtscrub.app/api/v1';

  // টেস্ট স্ট্যাজিং ইউআরএল
  // static const String baseUrl = 'https://nayem5001.binarybards.online/api/v1';
}
```

### ধাপ ৩: অ্যাপ্লিকেশন রান করা
ডিভাইসে প্রজেক্ট রান করার কমান্ড:
```bash
# এমুলেটর বা কানেক্টেড ফোনে অ্যাপ রান করতে
flutter run

# পারফরম্যান্স চেক করতে রিলিজ মোডে অ্যাপ রান করতে
flutter run --release
```

### ধাপ ৪: কোড জেনারেটর রান করা (Build Runner)
কাস্টম অবজেক্ট পার্সিং সোর্স কোড বা লোকাল ট্রান্সলেশন আপডেট করার পর জেনারেটর ফাইল রান করুন:
```bash
# প্রজেক্ট ক্যাশ ডিলিট করতে
flutter clean

# প্যাকেজ রিলোড করতে
flutter pub get

# জেনারেটর ফাইল তৈরি করতে
flutter pub run build_runner build --delete-conflicting-outputs
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **Staging Server:** কিউএ (QA) টেস্টিং এপিআই ইউআরএল।
*   **Production Server:** লাইভ ডাটাবেজ এপিআই ইউআরএল।

---

# Testing Guide (টেস্টিং গাইড)

### লোকাল এনভায়রনমেন্ট যাচাই (Flutter Doctor)
*   **ধাপ:** টার্মিনালে `flutter doctor` কমান্ড রান করুন।
*   **প্রত্যাশিত ফলাফল:** অ্যান্ড্রয়েড টুলচেন, এক্সকোড সেটিংস এবং ডিভাইস সেটিংস গ্রিন টিক সহ সাকসেস দেখাবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `Target OS version mismatch` | আইওএস পডফাইল ডিরেক্টরি ভার্সন সেটিং কম দেওয়া হয়েছে | `ios/Podfile` ফাইলে প্ল্যাটফর্ম ভার্সন বৃদ্ধি করুন (যেমন: `platform :ios, '13.0'`)। |
| `Dart SDK version incompatible` | লোকাল ফ্লাটার এসডিকে প্রজেক্টের সাথে ম্যাচ করছে না | FVM (Flutter Version Manager) ব্যবহার করে গ্লোবাল ভার্সন `3.10.4` সেভ করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   রিলিজ দেওয়ার আগে সোর্স কোড থেকে সমস্ত ডিবাগ কনসোল লগার ডিসেবল করুন।
*   নিশ্চিত করুন `ApiConstants.baseUrl` প্রোডাকশন এপিআই এন্ডপয়েন্টে সেট করা আছে।

---

# Troubleshooting (ডিবাগিং গাইড)
*   বিল্ড করার সময় কোনো ক্যাশ মেমরি এরর বা ওল্ড ফাইল সেটিংস এরর আসলে টার্মিনালে `flutter clean` দিয়ে পুনরায় রান করান।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **ফ্লাটার ভার্সন লক:** এই প্রজেক্টটি ডেভেলপ করার সময় ফ্লাটার SDK ভার্সন `3.10.4` এর ওপর লক করা হয়েছে। অন্য কোনো নতুন ভার্সন দিয়ে রান করালে কোডবেজ প্লাগইন কম্প্যাটিবিলিটি ইরর দেখাতে পারে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. ফ্লাটার SDK ভার্সন `3.10.4` ইনস্টল করুন।
2. অ্যান্ড্রয়েড স্টুডিও ও এক্সকোড এনভায়রনমেন্ট কনফিগার করুন।
3. প্রজেক্টের `pubspec.yaml` ফাইল থেকে লাইব্রেরি ভার্সনগুলো কপি করুন।
4. কোডে এপিআই কনস্ট্যান্ট ক্লাস সেটিংস বসান।
5. কানেক্টেড ডিভাইসে রান বা রিলিজ কমান্ড ব্যবহার করে প্রজেক্ট চালু করুন।

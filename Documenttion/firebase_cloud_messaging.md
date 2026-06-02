# Firebase Cloud Messaging (FCM) Integration Guide (FCM গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে Firebase Cloud Messaging (FCM) ব্যবহার করে পুশ নোটিফিকেশন সেটআপ এবং তার ব্যাকগ্রাউন্ড ও ফোরগ্রাউন্ড সার্ভিস ম্যানেজমেন্ট সম্পর্কে আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
Firebase Cloud Messaging (FCM) হল একটি ক্রস-প্ল্যাটফর্ম মেসেজিং সলিউশন যা কোনো খরচ ছাড়াই বিশ্বস্তভাবে বার্তা পাঠাতে সাহায্য করে। SMRTSCRUB অ্যাপে রিমোট পুশ নোটিফিকেশন পাঠানোর জন্য FCM ব্যবহার করা হয়। অ্যাপটি স্টার্টআপে FCM সার্ভারে রেজিস্টার হয়ে একটি ইউনিক ডিভাইস টোকেন জেনারেট করে এবং ফোরগ্রাউন্ড, ব্যাকগ্রাউন্ড ও টার্মিনেটেড (বন্ধ) অবস্থায় আগত নোটিফিকেশন পে-লোড রিসিভ করে।

---

# Architecture (আর্কিটেকচার)
```
[Backend Server] ──(নোটিফিকেশন ডাটা পাঠায়)──> [FCM Gateway]
                                                    │
                                                    ├──> অ্যাপ ফোরগ্রাউন্ডে থাকলে: onMessage ফায়ার হয়
                                                    │    └──> লোকাল নোটিফিকেশন রিকল এবং ইউআই রিফ্রেশ
                                                    │
                                                    └──> অ্যাপ ব্যাকগ্রাউন্ডে/বন্ধ থাকলে:
                                                         সিস্টেম ব্যানার শো করে ও ব্যাকগ্রাউন্ড হ্যান্ডলার কল করে
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/push_notification_service.dart` - FCM লিসেনার, পারমিশন রিকোয়েস্ট এবং ডিভাইস টোকেন সংক্রান্ত কাজের মূল ক্লাস ফাইল।
*   `lib/main.dart` - অ্যাপ ইনিশিয়ালাইজেশন ব্লকে নোটিফিকেশন ইন্টারসেপ্টর রেজিস্টার করার ফাইল।
*   `android/app/src/main/AndroidManifest.xml` - পুশ নোটিফিকেশনের অনুমতি কোড সংবলিত ম্যানিফেস্ট ফাইল।
*   `ios/Runner/AppDelegate.swift` - আইওএস এপিএনএস নোটিফিকেশন সেশন রেজিস্টার করার এন্ট্রি ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  firebase_messaging: ^16.2.0
  firebase_core: ^4.4.0
  get: ^4.7.3
```
*   `firebase_messaging`: ডিভাইস রেজিস্ট্রেশন টোকেন পেতে এবং নোটিফিকেশন স্ট্রিম হ্যান্ডেল করার অফিশিয়াল প্লাগইন।

---

# Firebase Configuration (Firebase কনফিগারেশন)
1. **Firebase Console** ওপেন করুন।
2. **Project Settings → Cloud Messaging** ট্যাবে যান।
3. **Apple app sharing settings** প্যানেলে যান।
4. অ্যাপল ডেভেলপার পোর্টাল থেকে ডাউনলোড করা **APNs Authentication Key** (`.p8` ফাইল) আপলোড করুন। অ্যাপলের **Key ID** এবং **Team ID** এন্ট্রি করে সাবমিট করুন।
5. (অ্যান্ড্রয়েডে পুশ নোটিফিকেশন কাজ করার জন্য অতিরিক্ত এপিএনএস কনফিগারেশনের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Apple Developer Account:** আইওএস ডিভাইসে পুশ নোটিফিকেশন সচল করার জন্য এপিএনএস কি (`.p8`) জেনারেট করতে এবং পুশ নোটিফিকেশন আইডেন্টিফায়ার সচল করতে পেইড মেম্বারশিপ অ্যাকাউন্ট প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **FCM Device Token:** `FirebaseMessaging.instance.getToken()` কল করে প্রাপ্ত ইউনিক ডিভাইস টোকেন। এটি ব্যাকএন্ড ডাটাবেজে স্টোর করে নির্দিষ্ট ব্যবহারকারীকে নোটিফিকেশন রাউট করা হয়।
*   **APNs Token:** আইওএস ডিভাইসের জন্য রিয়েল-টাইম পুশ কানেকশন কি, যা FCM টোকেন জেনারেট করার সময় ব্যাকগ্রাউন্ডে চেক করা হয়।

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

### ধাপ ১: টপ-লেভেল ব্যাকগ্রাউন্ড হ্যান্ডলার ফাংশন তৈরি করা
ব্যাকগ্রাউন্ড পুশ লিসেনারটি অবশ্যই যেকোনো ক্লাসের বাইরে একটি টপ-লেভেল ফাংশন হতে হবে এবং এর সাথে `@pragma('vm:entry-point')` যুক্ত থাকতে হবে:
```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // ব্যাকগ্রাউন্ড নোটিফিকেশন রিসিভ লজিক এখানে লিখুন
}
```

### ধাপ ২: ইন্টারসেপ্টর ও লিসেনার সেটিংস
`FirebaseNotificationService` ক্লাসের ভেতর লিসেনার মেথড লিখুন:
```dart
static Future<void> setupInterceptors() async {
  // টোকেন রিফ্রেশ লিসেনার
  _messaging.onTokenRefresh.listen((newToken) {
    onTokenRefresh?.call(newToken);
  });

  // ফোরগ্রাউন্ড নোটিফিকেশন রিসিভার
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (Get.isRegistered<NotificationController>()) {
      final controller = Get.find<NotificationController>();
      controller.fetchNotifications(isRefresh: true); // ইউআই ডাটা আপডেট
    }
    onForegroundMessage?.call(message);
  });

  // নোটিফিকেশন ব্যানার ক্লিক লিসেনার (অ্যাপ ব্যাকগ্রাউন্ডে থাকলে)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    onNotificationTap?.call(message);
  });

  // নোটিফিকেশন ব্যানার ক্লিক লিসেনার (অ্যাপ সম্পূর্ণ বন্ধ থাকলে)
  final initialMessage = await _messaging.getInitialMessage();
  if (initialMessage != null) {
    onNotificationTap?.call(initialMessage);
  }

  // ব্যাকগ্রাউন্ড হ্যান্ডলার রেজিস্টার
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
```

### ধাপ ৩: পারমিশন ও আইওএস এপিএনএস টোকেন ভ্যালিডেশন
আইওএস ডিভাইসে অনেক সময় এপিএনএস টোকেন রিসিভ হতে দেরি হয়, যার ফলে এফসিএম টোকেন এরর আসে। এটি এড়াতে নিচের নিয়মে রিট্রাই লুপ লিখুন:
```dart
static Future<String?> requestPermissionAndGetToken() async {
  final settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return null;
  }

  String? token;
  try {
    if (Platform.isIOS) {
      String? apnsToken = await _messaging.getAPNSToken();
      int retryCount = 0;
      // এপিএনএস টোকেন নাল থাকলে সর্বোচ্চ ৩ বার রিট্রাই লুপ চলবে
      while (apnsToken == null && retryCount < 3) {
        await Future.delayed(const Duration(seconds: 2));
        apnsToken = await _messaging.getAPNSToken();
        retryCount++;
      }
    }
    token = await _messaging.getToken();
  } catch (e) {
    // এরর হ্যান্ডেল করুন
  }
  return token;
}
```

### ধাপ ৪: বুটস্ট্র্যাপ রেজিস্ট্রেশন
`lib/main.dart` ফাইলে অ্যাপ রান হওয়ার আগেই নোটিফিকেশন ইন্টারসেপ্টর সচল করুন:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  await FirebaseNotificationService.setupInterceptors();
  runApp(MyApp());
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **ডেটাবেজ টেবিল:** ব্যবহারকারী টেবিলে স্ট্রিং টাইপ `deviceToken` ফিল্ড থাকতে হবে যেখানে সচল ডিভাইস আইডি জমা রাখা হবে।
*   **সিঙ্ক রাউট:** `PATCH /api/v1/users/profile` (বডি: `{"deviceToken": "..."}`).
*   **মেসেজিং এপিআই:** ব্যাকএন্ড Firebase Admin SDK ব্যবহার করে ইউজারের `deviceToken` টার্গেট করে পুশ নোটিফিকেশন ডিসপ্যাচ করবে।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: নোটিফিকেশন টোকেন জেনারেট যাচাই
*   **ধাপ:** অ্যাপ চালু করে সাইন-ইন সম্পন্ন করুন এবং ডিবাগ কনসোল চেক করুন।
*   **প্রত্যাশিত ফলাফল:** কনসোলে সঠিক FCM Device Token প্রিন্ট হবে।

### টেস্ট কেস ২: নোটিফিকেশন রিসিভ টেস্ট
*   **ধাপ:** Firebase Console-এ গিয়ে **Engage → Messaging** ক্লিক করুন। কাস্টম পুশ টেস্ট ট্রিগার করে টার্গেট টোকেন দিয়ে সেন্ড করুন।
*   **প্রত্যাশিত ফলাফল:** অ্যাপ ব্যাকগ্রাউন্ডে থাকলে সাথে সাথে ফোনে পুশ নোটিফিকেশন ব্যানার শো করবে। অ্যাপ ওপেন থাকলে ফোরগ্রাউন্ড লিসেনার ডাটা রিসিভ করে নোটিফিকেশন কাউন্ট আপডেট করবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `APNS token is not available` | আইওএস এপিএনএস রেজিস্ট্রেশন সম্পন্ন হওয়ার আগেই টোকেন চাওয়া হয়েছে | এফসিএম টোকেন চাওয়ার আগে `getAPNSToken()` মেথড চেক করতে রিট্রাই লুপ বাস্তবায়ন করুন। |
| ব্যাকগ্রাউন্ড হ্যান্ডলার ক্র্যাশ করছে | হ্যান্ডলার মেথডটি কোনো ক্লাসের ভেতর ডিফাইন করা হয়েছে | হ্যান্ডলারটি গ্লোবাল স্কোপে (টপ-লেভেল) ডিফাইন করুন এবং `@pragma('vm:entry-point')` যুক্ত করুন। |
| আইওএস ফোনে পুশ আসে না | এপিএনএস সার্টিফিকেশন (.p8) Firebase ড্যাশবোর্ডে লিংক নেই | অ্যাপল ডেভেলপার একাউন্ট থেকে পুশ কি জেনারেট করে Firebase-এ আপলোড করুন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   Xcode-এর Signing & Capabilities প্যানেলে গিয়ে **Push Notifications** এবং **Background Modes (Remote notifications)** অপশন দুটি অন করা আছে কিনা নিশ্চিত হোন।

---

# Troubleshooting (ডিবাগিং গাইড)
*   ডিভাইসে নোটিফিকেশন না আসলে চেক করুন ইন্টারনেট নেটওয়ার্কে ফায়ারওয়াল বা পোর্ট (5228, 5229, 5230) ব্লক করা আছে কিনা।
*   আইওএস সিমুলেটরে পুশ নোটিফিকেশন টেস্ট করতে অ্যাপল সিলিকন ম্যাকবুক ও এক্সকোড ১৪+ ভার্সন প্রয়োজন। অনথ্যায় রিয়েল আইওএস ফোন ব্যবহার করে টেস্ট করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   ইন্টারসেপ্টর সেটিংস `main()` ফাংশনে আগে সচল করতে হবে যাতে অ্যাপ ব্যাকগ্রাউন্ডে নোটিফিকেশন ক্লিক ক্যাচ করতে পারে। নোটিফিকেশন পারমিশন ও টোকেন চাওয়ার কাজ ব্যবহারকারী লগইন করার পর সচল করা উচিত।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `firebase_messaging` প্যাকেজটি ইম্পোর্ট করুন।
2. টপ-লেভেল `@pragma('vm:entry-point')` ব্যাকগ্রাউন্ড হ্যান্ডলার ডিফাইন করুন।
3. `setupInterceptors()` এবং এপিএনএস টোকেন রিট্রাই লুপ মেথডটি তৈরি করুন।
4. লগইন ও প্রোফাইল রিলোড ফ্লোতে ব্যাকএন্ড ডিভাইস টোকেন সিঙ্ক মেথডটি রান করুন।

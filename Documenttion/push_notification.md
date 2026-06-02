# Local Push Notifications Guide (লোকাল নোটিফিকেশন গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে লোকাল পুশ নোটিফিকেশন (Local Push Notifications) সেটআপ, কাস্টম অ্যান্ড্রয়েড চ্যানেল কনফিগারেশন এবং নোটিফিকেশনে ট্যাপ করে ডাউনলোড করা ফাইল ওপেন করার নিয়ম সম্পর্কে বিস্তারিত নির্দেশিকা দেওয়া হয়েছে।

---

# Overview (পরিচিতি)
লোকাল নোটিফিকেশন ক্লায়েন্ট ডিভাইস থেকে সরাসরি প্রদর্শন করা হয় (এতে সার্ভার কলিং বা FCM গেটওয়ের প্রয়োজন হয় না)। SMRTSCRUB অ্যাপে লোকাল নোটিফিকেশন প্রধানত দুটি কাজে ব্যবহার করা হয়:
1.  **ডাউনলোড সম্পন্ন নোটিফিকেশন:** কোনো প্রেফারেন্স কার্ড ডাউনলোড সম্পন্ন হলে ব্যবহারকারীকে লোকাল অ্যালার্ট পাঠানো হয় এবং নোটিফিকেশনে ট্যাপ করলে সরাসরি ডাউনলোড করা পিডিএফ ফাইলটি ওপেন হয়।
2.  **ফোরগ্রাউন্ড পুশ অ্যালার্ট:** অ্যাপ ওপেন থাকা অবস্থায় কোনো দূরবর্তী FCM পুশ নোটিফিকেশন রিসিভ হলে, তা স্ক্রিনে দৃশ্যমান ব্যানার হিসেবে প্রদর্শন করতে লোকাল নোটিফিকেশনের সাহায্য নেওয়া হয়।

---

# Architecture (আর্কিটেকচার)
```
[App Trigger (ডাউনলোড সম্পন্ন)] ──(লোকাল পে-লোড পাঠায়)──> [NotificationService]
                                                                │
                                                                ├──> অ্যান্ড্রয়েড চ্যানেল/আইওএস ব্যানার সেটিংস লোড করে
                                                                ├──> স্ক্রিনে লোকাল নোটিফিকেশন শো করে
                                                                └──> ইউজার নোটিফিকেশন ব্যানারে ট্যাপ করে
                                                                         │
                                                                         └──> OpenFile লাইব্রেরির মাধ্যমে ফাইল ওপেন হয়
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/notification_service.dart` - লোকাল নোটিফিকেশন প্লাগইন ইনিশিয়ালাইজেশন, চ্যানেল তৈরি এবং অ্যালার্ট শো করার মেথড ধারণকারী সিঙ্গেলটন ফাইল।
*   `lib/main.dart` - অ্যাপ চালুর প্রারম্ভে `NotificationService().init()` কল করার এন্ট্রি ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  flutter_local_notifications: ^20.1.0
  open_file: ^3.5.11
```
*   `flutter_local_notifications`: অ্যান্ড্রয়েড ও আইওএসের নোটিফিকেশন এপিআই র্যাপ করার মূল প্লাগইন।
*   `open_file`: নোটিফিকেশন ট্যাপ করার পর পিডিএফ ফাইলটি ডিভাইসের ডিফল্ট পিডিএফ রিডারে সরাসরি ওপেন করতে ব্যবহৃত প্যাকেজ।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (লোকাল নোটিফিকেশন এবং Firebase সম্পূর্ণ আলাদা প্রসেস; এর জন্য কোনো Firebase কনফিগারেশনের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   লোকাল নোটিফিকেশন ফিচার ব্যবহারের জন্য কোনো থার্ড পার্টি অ্যাকাউন্ট বা ডেভেলপার পোর্টাল সেটিংসের প্রয়োজন নেই।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Android Channel IDs:** অ্যান্ড্রয়েড সিস্টেমে নোটিফিকেশন বিভাগ আলাদা করার জন্য ব্যবহৃত ইউনিক আইডি স্ট্রিং (যেমন: `download_channel` বা `push_channel`)।
*   **File Path Payload:** নোটিফিকেশন ক্লিক হ্যান্ডলারের জন্য পাঠানো ডাউনলোড করা পিডিএফ ফাইলের লোকাল ডিরেক্টরি পাথ স্ট্রিং।

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

### ধাপ ১: সিঙ্গেলটন নোটিফিকেশন সার্ভিস তৈরি করা
[notification_service.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/notification_service.dart) ফাইলটি তৈরি করে কনফিগার করুন:
```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          // নোটিফিকেশনে ক্লিক করলে লোকাল ফাইলটি ওপেন হবে
          await OpenFile.open(response.payload);
        }
      },
    );
  }
}
```

### ধাপ ২: ডাউনলোড অ্যালার্ট মেথড তৈরি করা
প্রেফারেন্স কার্ড পিডিএফ ফাইল ডাউনলোড কমপ্লিট হওয়ার পর নোটিফিকেশন ট্রিগার করার লজিক:
```dart
Future<void> showDownloadNotification({
  required String filePath,
  required String fileName,
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'download_channel',
        'Downloads',
        channelDescription: 'Notifications for downloaded files',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Download Complete',
    '$fileName has been downloaded.',
    platformChannelSpecifics,
    payload: filePath, // ট্যাপ করলে ফাইল ওপেন করার জন্য লোকাল ফাইল পাথ পাঠানো হচ্ছে
  );
}
```

### ধাপ ৩: ফোরগ্রাউন্ড পুশ অ্যালার্ট মেথড তৈরি করা
এফসিএম থেকে আসা ডেটা ফোরগ্রাউন্ডে লোকাল ব্যানারে দেখানোর লজিক:
```dart
Future<void> showPushNotification({
  required String title,
  required String body,
  String? payload,
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'push_channel',
        'Push Notifications',
        channelDescription: 'Notifications for push messages',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
      );

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosPlatformChannelSpecifics,
  );

  final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}
```

### ধাপ ৪: বুটস্ট্র্যাপ রান
[main.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/main.dart) ফাইলে সার্ভিসটি সচল করুন:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // Firebase লোড হওয়ার আগে ইনিশিয়েলাইজ করুন
  runApp(MyApp());
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   লোকাল নোটিফিকেশনের জন্য কোনো ব্যাকএন্ড কনফিগারেশনের প্রয়োজন নেই।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: ডাউনলোড নোটিফিকেশন যাচাই
*   **ধাপ:** অ্যাপের ভেতর থেকে যেকোনো প্রেফারেন্স কার্ড ডাউনলোড করুন।
*   **প্রত্যাশিত ফলাফল:** ডাউনলোড প্রসেস শেষে ফোনের স্ট্যাটাস বারে "Download Complete" নোটিফিকেশন ব্যানার ভেসে উঠবে।

### টেস্ট কেস ২: ফাইল ওপেন টেস্ট
*   **ধাপ:** ডাউনলোড সম্পন্ন নোটিফিকেশন ব্যানারের ওপর ক্লিক করুন।
*   **প্রত্যাশিত ফলাফল:** ফোন থেকে পিডিএফ ভিউয়ার রিকোয়েস্ট প্যানেল ওপেন হবে এবং ডাউনলোড করা ফাইলটি দেখতে পাবেন।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| নোটিফিকেশন শো করছে না | সিস্টেমে নোটিফিকেশন পারমিশন অফ করা আছে | মোবাইল সেটিংস থেকে অ্যাপের নোটিফিকেশন অনুমতি অন করুন। |
| অ্যান্ড্রয়েডে আইকন এরর আসছে | `@mipmap/launcher_icon` ফাইলটি ডিরেক্টরিতে নেই | অ্যান্ড্রয়েড ড্রয়েবল ফোল্ডারে সঠিক অ্যাপ আইকন ইমেজ ফাইলের নাম যাচাই করুন। |
| নোটিফিকেশন ক্লিক করলে ফাইল খোলে না | ফাইল পাথটি ইন-ভ্যালিড অথবা ফাইল ডিলিট হয়ে গেছে | নিশ্চিত করুন পে-লোডে পাঠানো ফাইল পাথ স্ট্রিংটি ফিজিক্যালি ডিভাইসে বিদ্যমান। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   নিশ্চিত করুন রিলিজ বিল্ড কম্পাইল করার আগে অ্যান্ড্রয়েড রিসোর্সের ভেতর `@mipmap/launcher_icon` ফাইলটি সঠিক ফরম্যাটে (PNG) যুক্ত করা আছে।

---

# Troubleshooting (ডিবাগিং গাইড)
*   অ্যাপ সেটিংস থেকে গ্লোবাল নোটিফিকেশন চ্যানেল ইনেবল আছে কিনা চেক করুন।
*   ফাইল ডাউনলোড পাথের জন্য সর্বদা অ্যাপের ডিরেক্টরি পাথ (`path_provider` দ্বারা জেনারেট করা) ব্যবহার করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   অ্যান্ড্রয়েড ১৩+ (API level 33) ভার্সনগুলোতে অ্যাপ চালুর পর লোকাল নোটিফিকেশন দেখানোর জন্য আলাদাভাবে রান-টাইম পারমিশন (`POST_NOTIFICATIONS`) চাইতে হবে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `flutter_local_notifications` এবং `open_file` প্যাকেজ যুক্ত করুন।
2. অ্যান্ড্রয়েড ও আইওএস এর জন্য প্রারম্ভিক ইনিশিয়ালাইজ সেটিংস কোড লিখুন।
3. নোটিফিকেশন চ্যানেলগুলোর জন্য আলাদা আইডি ও ডেসক্রিপশন সেট করুন।
4. অন-ট্যাপ ট্রিগার হ্যান্ডলারে পে-লোড রিসিভ করে `OpenFile` কল করার লজিক যুক্ত করুন।

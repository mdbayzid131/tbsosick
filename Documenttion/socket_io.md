# Socket.IO Integration Guide (সকেট ইন্টিগ্রেশন গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে Socket.IO ক্লায়েন্ট লাইব্রেরি ব্যবহার করে রিয়েল-টাইম কানেকশন, প্রাইভেট রুম ম্যাপিং এবং ইভেন্ট লিসেনিং সেটিংস সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)

Socket.IO রিয়েল-টাইমে কোনো প্রকার পোলিং (polling) ছাড়াই সার্ভার ও ক্লায়েন্টের মধ্যে ডাটা আদান-প্রদান করতে সাহায্য করে। SMRTSCRUB অ্যাপে ইনস্ট্যান্ট চ্যাট মেসেজ এবং নোটিফিকেশন সিঙ্ক করার জন্য Socket.IO ব্যবহার করা হয়। কানেকশন চালু হওয়ার পর অ্যাপটি ইউজার আইডি দিয়ে সার্ভারে রেজিস্ট্রেশন সেশন শুরু করে এবং একটি প্রাইভেট রুমে সংযুক্ত হয়।

---

# Architecture (আর্কিটেকচার)

```
[Flutter Client] ──(অথেন্টিকেশন হেডার টোকেন)──> [Socket.IO Server]
        │                                            │
        ├──> joinRoom('user::{userId}') <────────────┤
        ├──> Listen: 'notification:new' <────────────┤ (লোকাল ইউআই নোটিফিকেশন রিলোড করে)
        ├──> Listen: 'new-message' <─────────────────┤ (চ্যাট বা রিসিভ মেসেজ ইভেন্ট রান করে)
        └──> Emit: 'send-message' ──────────────────>┘
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)

- `lib/core/services/socket_service.dart` - সকেট কানেকশন, ডিসকানেকশন, ইভেন্ট হ্যান্ডলার এবং রুম সিঙ্কিং মেথড ধারণকারী গেটএক্স সার্ভিস।
- `lib/config/constants/api_constants.dart` - সকেট বেস ইউআরএল জেনারেট করার জন্য এপিআই কনস্ট্যান্ট পাথ রিড করার ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)

```yaml
dependencies:
  socket_io_client: ^3.1.4
  get: ^4.7.3
```

- `socket_io_client`: নোডজেএস (NodeJS) সকেট সার্ভারের সাথে ক্লায়েন্ট সেশন ওপেন করার জন্য অফিসিয়াল ডার্ট প্যাকেজ।

---

# Firebase Configuration (Firebase কনফিগারেশন)

- (FCM এবং Socket.IO আলাদা চ্যানেল; এর জন্য কোনো Firebase সেটিংসের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)

- সকেট কানেকশন সেটআপের জন্য আলাদা কোনো থার্ড পার্টি ডেভেলপার অ্যাকাউন্টের প্রয়োজন নেই।

---

# Credentials (ক্রেডেন্সিয়াল)

- **Bearer Token:** SharedPreferences-এ থাকা `bearerToken` যা সকেট কানেকশনের অপশন বিল্ডারে অথ হেডার কি হিসেবে পাঠানো হয়।
- **User ID:** নির্দিষ্ট ব্যবহারকারীর প্রাইভেট রুমে ঢোকার জন্য আইডি স্ট্রিং (যেমন: `user::69fa359a3fc3858c40265443`)।

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

### ধাপ ১: সকেট সার্ভিস ক্লাস কনফিগার করা

[socket_service.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/socket_service.dart) ফাইলটি ক্রিয়েট করে কনফিগার করুন:

```dart
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/presentation/controllers/notification_controller.dart';

class SocketService extends GetxService {
  socket_io.Socket? _socket;
  socket_io.Socket? get socket => _socket;

  final isConnected = false.obs;
  void Function(dynamic data)? onNotificationReceived;
  void Function(dynamic data)? onMessageReceived;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  Future<void> _initSocket() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);
    final userId = await StorageService.getString(StorageConstants.userId);

    if (token.isEmpty) {
      Helpers.warning('Socket initialization skipped: No auth token');
      return;
    }

    // এপিআই ইউআরএল থেকে সকেট বেস পাথ জেনারেট করা হচ্ছে (e.g. https://api.smrtscrub.app)
    final baseUrl = ApiConstants.baseUrl.replaceAll('/api/v1', '');

    _socket = socket_io.io(
      baseUrl,
      socket_io.OptionBuilder()
          .setTransports(['websocket']) // পোলিং এড়াতে শুধুমাত্র পিওর ওয়েবসকেট সচল করা হচ্ছে
          .setAuth({'token': token})     // হ্যান্ডশেকে টোকেন পাঠানো হচ্ছে
          .enableAutoConnect()
          .enableForceNew()
          .build(),
    );

    _setupListeners(userId);
  }

  void _setupListeners(String userId) {
    _socket?.onConnect((_) {
      Helpers.info('Socket connected');
      isConnected.value = true;
      if (userId.isNotEmpty) {
        registerUser(userId);
        joinRoom('user::$userId'); // ইউজারের কাস্টম প্রাইভেট রুমে জয়েন করা
      }
    });

    _socket?.onDisconnect((_) {
      isConnected.value = false;
    });

    _socket?.onConnectError((err) => isConnected.value = false);

    // নোটিফিকেশন ইভেন্ট রিসিভার লুপ
    _socket?.on('notification:new', (data) => _handleIncomingNotification(data));
    _socket?.on('new-notification', (data) => _handleIncomingNotification(data));

    // নতুন চ্যাট মেসেজ লিসেনার
    _socket?.on('new-message', (data) => onMessageReceived?.call(data));
  }

  void _handleIncomingNotification(dynamic data) {
    if (Get.isRegistered<NotificationController>()) {
      // রিয়েল-টাইমে নোটিফিকেশন লিস্ট এপিআই কল করে সিনক্রোনাইজ করা
      Get.find<NotificationController>().fetchNotifications(isRefresh: true);
    }
    onNotificationReceived?.call(data);
  }

  void registerUser(String userId) {
    _socket?.emit('register', userId);
  }

  void joinRoom(String roomId) {
    _socket?.emit('join-room', roomId);
  }

  void leaveRoom(String roomId) {
    _socket?.emit('leave-room', roomId);
  }

  void sendMessage(String roomId, String senderId, String content) {
    _socket?.emit('send-message', {
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    isConnected.value = false;
  }
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)

- **Socket.IO Server:** এপিআই গেটওয়ের পোর্টে রান হতে হবে।
- **ইভেন্ট প্রসেসর লজিক:**
  - `register` (প্যারামিটার: `userId`) - অ্যাক্টিভ সকেট সেশন ইউজার ডাটাবেজ কলামে ম্যাপ করা।
  - `join-room` (প্যারামিটার: `roomId`) - ইউজারকে নির্দিষ্ট চ্যাট চ্যানেলে বাইন্ড করা।
  - `send-message` (প্যারামিটার: `{"roomId", "senderId", "content"}`) - মেসেজ ডাটাবেজে রাইট করা এবং ওই রুমের অন্য ইউজারদের `new-message` ইভেন্টে ব্রডকাস্ট করা।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: রিয়েল-টাইম নোটিফিকেশন সিঙ্ক

- **ধাপ:** অ্যাপ ওপেন রাখুন, ব্যাকএন্ড ডাটাবেজে কাস্টম নোটিফিকেশন তৈরি করুন এবং সার্ভার সাইড থেকে ক্লায়েন্ট ইউজারের জন্য `notification:new` ইভেন্ট এমিট করুন।
- **প্রত্যাশিত ফলাফল:** নোটিফিকেশন ব্যানার রিসিভ হবে এবং স্ক্রিন রিলোড ছাড়াই নোটিফিকেশন কাউন্ট আপডেট হবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা)          | Root Cause (কারণ)                           | Fix (সমাধান)                                                                   |
| ------------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------ |
| সকেট কানেক্ট হচ্ছে না           | ট্রান্সপোর্ট অপশনে ওয়েবসকেট ফোর্স করা হয়নি | নিশ্চিত করুন সকেট অপশনে `.setTransports(['websocket'])` দেওয়া আছে।             |
| `Socket initialization skipped` | স্টার্টআপে সকেট টোকেন খুঁজে পায়নি           | ইউজার লগইন করার পর সকেট সার্ভিসের `connect()` মেথডটি ম্যানুয়ালি রান করান।     |
| ইভেন্ট রিসিভ হচ্ছে না           | ভুল ডোমেন বা সকেট পাথ কনফিগার করা হয়েছে    | প্রজেক্ট সকেট পাথ কনফিগারেশন সেটিংস চেক করে ব্যাকএন্ড পাথের সাথে মিলিয়ে দেখুন। |

---

# Production Deployment (Pro-চেকলিস্ট)

- লাইভ বা প্রোডাকশন মোডে যাওয়ার সময় সকেট কানেকশন অবশ্যই সিকিউর প্রোটোকলে (`wss://`) চালনা করতে হবে।

---

# Troubleshooting (ডিবাগিং গাইড)

- সকেটের হ্যান্ডশেক ইরর বা কানেকশন ইস্যু ট্র্যাক করতে সকেট অপশনে লগার সচল করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)

- > [!IMPORTANT]
  > **গুরুত্বপূর্ণ ফাইন্ডিং:** কোডবেজে `SocketService` ফাইলটি তৈরি করা হলেও এটি [initial_binding.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/bindings/initial_binding.dart) ফাইলের ভেতর ইনিশিয়ালাইজ বা পুট (`Get.put`) করা হয়নি। যার ফলে রান-টাইমে এটি কাজ করবে না।
- **সমাধান:** `initial_binding.dart` ফাইলটি ওপেন করুন, `socket_service.dart` ইম্পোর্ট করুন এবং মেথডে এড করুন:
  ```dart
  Get.put(SocketService(), permanent: true);
  ```

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)

1. `socket_io_client` প্যাকেজটি ইম্পোর্ট করুন।
2. সার্ভারের ইউআরএল ম্যাপ করে সকেট অপশন কনফিগারেশন মেথড লিখুন।
3. লোকাল সেশন টোকেন হ্যান্ডশেক প্যারামিটারস সেটিংস ইমপোর্ট করুন।
4. ইভেন্ট লিসেনার তৈরি করে চ্যাট ইভেন্টগুলো রাউট করুন।
5. অ্যাপের গ্লোবাল ইনিশিয়াল বাইন্ডিংয়ে ক্লাস অবজেক্টটি পুট করুন।

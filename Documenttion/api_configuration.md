# API & Network Configuration Guide (এপিআই ও নেটওয়ার্ক কনফিগারেশন গাইড)

এই ফাইলে ফ্লাটার অ্যাপ্লিকেশনে Dio প্যাকেজ ব্যবহার করে সেন্ট্রালাইজড এপিআই ক্লায়েন্ট কনফিগারেশন, রিকোয়েস্ট ইন্টারসেপ্টর এবং টোকেন অটো-রিফ্রেশ বাস্তবায়নের নির্দেশিকা দেওয়া হয়েছে।

---

# Overview (পরিচিতি)
SMRTSCRUB অ্যাপটি ব্যাকএন্ড এপিআই সার্ভারের সাথে সংযোগ স্থাপনের জন্য **Dio** প্যাকেজের উপর ভিত্তি করে নির্মিত একটি গ্লোবাল `ApiClient` ক্লাস ব্যবহার করে। এটি রিকোয়েস্টে হেডার ইনজেক্ট করা, কনসোল লগে রিকোয়েস্ট প্রিন্ট করা, এরর কোড ম্যাপ করা এবং `401 Unauthorized` রেসপন্স আসলে লোকাল রিফ্রেশ টোকেন ব্যবহার করে অটো-রিবুট ও রিকোয়েস্ট রিট্রাই মেকানিজম সম্পন্ন করে।

---

# Architecture (আর্কিটেকচার)
```
[GetX Controllers / Repositories] ──> [ApiClient (getData / postData)]
                                                    │
                                                    ├──> onRequest (অথ টোকেন ইনজেক্ট করে)
                                                    ├──> HTTP রিকোয়েস্ট সার্ভারে পাঠায়
                                                    └──> onError (Catch 401 Unauthorized)
                                                             │
                                                             ├──> রিকোয়েস্ট কিউ লক করে এবং /auth/refresh-token কল করে
                                                             ├──> রিফ্রেশ সফল: ব্যর্থ রিকোয়েস্ট পুনরায় পাঠায়
                                                             └──> রিফ্রেশ ব্যর্থ: সেশন ডিলিট করে লগইন পেজে পাঠায়
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/api_client.dart` - সেন্ট্রালাইজড নেটওয়ার্ক ক্লায়েন্ট যা এপিআই কানেকশন, ইন্টারসেপ্টর এবং টোকেন লাইফসাইকেল হ্যান্ডেল করে।
*   `lib/config/constants/api_constants.dart` - অ্যাপের এপিআই বেস পাথ (`https://api.smrtscrub.app/api/v1`) এবং রাউটিং পাথ সংরক্ষণের কনস্ট্যান্ট ফাইল।
*   `lib/core/bindings/initial_binding.dart` - অ্যাপের গ্লোবাল বাইন্ডিং সেটিংস যেখানে `ApiClient` রেজিস্টার করা হয়।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  dio: ^5.9.0
  get: ^4.7.3
```
*   `dio`: রিকোয়েস্ট ইন্টারসেপ্টর, গ্লোবাল হেডার এবং ফাইল ডাউনলোড রিড করার সবচেয়ে শক্তিশালী এইচটিটিপি ক্লায়েন্ট।

---

# Firebase Configuration (Firebase কনফিগারেশন)
*   (এপিআই ক্লায়েন্ট এবং Firebase আলাদা মডিউল; এর জন্য কোনো Firebase সেটিংসের প্রয়োজন নেই)।

---

# Third Party Accounts (থার্ড PARTY অ্যাকাউন্ট)
*   কোনো থার্ড পার্টি অ্যাকাউন্টের প্রয়োজন নেই।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Bearer Token:** অথেনটিকেটেড রিকোয়েস্ট হেডারে `Authorization: Bearer <token>` হিসেবে রিড করা হয় (SharedPreferences কি: `bearerToken`)।
*   **Refresh Token:** সেশন সচল রাখতে নতুন অ্যাক্সেস টোকেন চাইতে এপিআই ইন্টারসেপ্টরে ব্যবহার করা হয় (SharedPreferences কি: `refreshToken`)।

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

### ধাপ ১: বেস কনফিগারেশন সেটিংস
[api_client.dart](file:///c:/Users/mdbay/StudioProjects/tbsosick/lib/core/services/api_client.dart) ফাইলের `onInit()` মেথডে Dio কনফিগার করুন:
```dart
@override
void onInit() {
  super.onInit();
  _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  _dio.interceptors.add(_buildInterceptor());
}
```

### ধাপ ২: রিকোয়েস্ট ও এরর ইন্টারসেপ্টর বাস্তবায়ন
রিকোয়েস্ট পাঠানোর আগে হেডার অ্যাড করা এবং এরর রেসপন্সে টোকেন রিফ্রেশ হ্যান্ডেল করার মেথড:
```dart
Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
  _bearerToken = await StorageService.getString(StorageConstants.bearerToken);
  
  // রিফ্রেশ টোকেন এন্ডপয়েন্ট ছাড়া অন্য সব রিকোয়েস্টে টোকেন ইনজেক্ট করা হচ্ছে
  if (_bearerToken.isNotEmpty && !options.path.contains(ApiConstants.refreshToken)) {
    options.headers['Authorization'] = 'Bearer $_bearerToken';
  }
  return handler.next(options);
}

Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
  // ৪০১ এরর ক্যাচ করা হচ্ছে (Unauthorized)
  if (e.response?.statusCode == 401 &&
      !e.requestOptions.path.contains(ApiConstants.refreshToken) &&
      !e.requestOptions.path.contains(ApiConstants.login)) {
    
    final refreshToken = await StorageService.getString(StorageConstants.refreshToken);
    if (refreshToken.isEmpty) {
      _forceLogout();
      return handler.next(e);
    }

    final refreshed = await _refreshToken();
    if (refreshed) {
      final retryResponse = await _retryRequest(e.requestOptions);
      return handler.resolve(retryResponse); // সফলভাবে নতুন টোকেন দিয়ে পুনরায় রিকোয়েস্ট পাঠানো হলো
    } else {
      _forceLogout();
      return handler.next(e);
    }
  }
  return handler.next(e);
}
```

### ধাপ ৩: থ্রেড-লক রিফ্রেশ টোকেন মেকানিজম
একাধিক রিকোয়েস্ট একসাথে ৪০১ এরর দিলে যাতে একাধিকবার রিফ্রেশ এপিআই কল না হয়, তার জন্য lock/Completer কোড:
```dart
static Future<bool>? _refreshFuture;

Future<bool> _refreshToken() async {
  if (_refreshFuture != null) {
    return _refreshFuture!; // চলমান রিফ্রেশ রিকোয়েস্টের Future শেয়ার করা হচ্ছে
  }

  final completer = Completer<bool>();
  _refreshFuture = completer.future;

  try {
    final refreshTokenValue = await StorageService.getString(StorageConstants.refreshToken);
    if (refreshTokenValue.isEmpty) {
      completer.complete(false);
      return false;
    }

    // ইন্টারসেপ্টর এড়াতে সম্পূর্ণ আলাদা নতুন Dio অবজেক্ট ব্যবহার করা হচ্ছে
    final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    final response = await refreshDio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshTokenValue},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authData = response.data['data'] ?? response.data;
      final newAccessToken = authData['accessToken'] ?? authData['token'];
      final newRefreshToken = authData['refreshToken'];

      if (newAccessToken != null) {
        await StorageService.setString(StorageConstants.bearerToken, newAccessToken);
      }
      if (newRefreshToken != null) {
        await StorageService.setString(StorageConstants.refreshToken, newRefreshToken);
      }
      completer.complete(true);
      return true;
    }
  } catch (e) {
    // এরর ট্র্যাকিং
  } finally {
    _refreshFuture = null; // থ্রেড-লক রিলিজ করা হলো
  }

  completer.complete(false);
  return false;
}
```

### ধাপ ৪: মাল্টিপার্ট ফাইল আপলোড সেটিংস
ফাইল বা ইমেজ আপলোড করার জন্য এপিআই মেথড:
```dart
class MultipartBody {
  final String key;
  final File file;
  const MultipartBody(this.key, this.file);
}

Future<Response> postMultipartData(
  String uri,
  Map<String, dynamic> body, {
  required List<MultipartBody> multipartBody,
}) async {
  try {
    final formData = FormData.fromMap(body);
    for (final part in multipartBody) {
      formData.files.add(
        MapEntry(part.key, await MultipartFile.fromFile(part.file.path)),
      );
    }
    return await _dio.post(uri, data: formData);
  } on DioException catch (e) {
    return _buildErrorResponse(e);
  }
}
```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)
*   **রিফ্রেশ এন্ডপয়েন্ট:** `POST /api/v1/auth/refresh-token` (বডি: `{"refreshToken": "..."}`)।
*   **টোকেন মেয়াদ ভ্যালিডেশন:** টোকেন জেনারেট করার সময় মেয়াদ ফিল্ড ম্যাপ করে রেসপন্স সেন্ড করা।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: রিফ্রেশ টোকেন ফ্লো যাচাই
*   **ধাপ:** ডিভাইসের SharedPreferences থেকে সচল `bearerToken` ডিলিট করে একটি ডামি ইন-ভ্যালিড স্ট্রিং পেস্ট করুন (কিন্তু `refreshToken` সঠিক রাখুন) এবং এমন পেজ রিলোড করুন যা এপিআই ডাটা রিকোয়েস্ট করে।
*   **প্রত্যাশিত ফলাফল:** অ্যাপটি ব্যাকগ্রাউন্ডে ৪০১ এরর ক্যাচ করবে, রিফ্রেশ টোকেন কল করে নতুন সচল অ্যাক্সেস টোকেন সেভ করবে এবং স্ক্রিনটি রি-রেন্ডার করে সাকসেস ডাটা দেখাবে (লগইন পেজে রিডাইরেক্ট হবে না)।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| রিফ্রেশ টোকেন এপিআই কল করার পর লুপ হচ্ছে | রিফ্রেশ পাথটিকে ইন্টারসেপ্টর এরর লুপ থেকে বাদ দেওয়া হয়নি | `_onError` মেথডে রিফ্রেশ টোকেন কলের পাথটি এক্সক্লুড করা আছে কিনা তা চেক করুন। |
| Connection Timed Out | সার্ভার নির্দিষ্ট সময়ের মধ্যে সাড়া দেয়নি | `BaseOptions`-এর ভেতর `connectTimeout` বাড়িয়ে দিন। |

---

# Production Deployment (Pro-চেকলিস্ট)
*   লাইভ বা প্রোডাকশন ইউআরএসের এসএসএল (SSL) সার্টিফিকেট অবশ্যই ভ্যালিড হতে হবে, অন্যথায় Dio সিকিউরিটি এক্সেপশন দিয়ে কানেকশন রিজেক্ট করে দেবে।

---

# Troubleshooting (ডিবাগিং গাইড)
*   ডিবাগিংয়ের সময় কনসোলে আসা রিকোয়েস্ট বডি, হেডার প্যারামিটার এবং রেসপন্স স্ট্যাটাস চেক করতে রিকোয়েস্ট লগার সচল করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   **রিফ্রেশ টোকেনের জন্য কেন আলাদা Dio ইনস্ট্যান্স ব্যবহার করা হয়?** প্রধান `_dio` ইনস্ট্যান্সের সাথে ইন্টারসেপ্টর অ্যাড করা আছে। রিফ্রেশ করার সময় যদি প্রধান ইনস্ট্যান্স ব্যবহার করা হয়, তবে তা পুনরায় onRequest রান করে রিফ্রেশ টোকেনের ওপর পুরাতন অ্যাক্সেস টোকেন ইনজেক্ট করে দেবে, যা ইনফিনিট লুপের সৃষ্টি করবে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `dio` ও `get` প্যাকেজ ইম্পোর্ট করুন।
2. `onInit()` মেথডে বেস কানেকশন প্যারামিটার ও ইন্টারসেপ্টর সচল করুন।
3. `onRequest` ও `_onError` লুপ মেকানিজম লিখুন।
4. Completer ব্যবহার করে লক-ভিত্তিক টোকেন রিফ্রেশ মেথড লিখুন।
5. এপিআই ভার্ব মেথডগুলো (GET, POST, Multipart) র্যাপ করে ডিক্লেয়ার করুন।

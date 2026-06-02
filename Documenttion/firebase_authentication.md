# Firebase & Backend Authentication Guide (অথেন্টিকেশন গাইড)

এই ফাইলে SMRTSCRUB অ্যাপে ব্যবহৃত অথেন্টিকেশন ফ্লো (ইমেইল/পাসওয়ার্ড ও ওটিপি ভেরিফিকেশন এবং সোশ্যাল মিডিয়া লগইন) এবং তার বাস্তবায়ন সম্পর্কে বিস্তারিত বর্ণনা করা হয়েছে।

---

# Overview (পরিচিতি)
SMRTSCRUB অ্যাপে একটি হাইব্রিড অথেন্টিকেশন মডেল ব্যবহার করা হয়েছে। সাধারণ লগইনের জন্য ইমেইল, পাসওয়ার্ড এবং ইমেইল ওটিপি (OTP) ভেরিফিকেশন সিস্টেম ব্যবহার করা হয়। সোশ্যাল লগইনের (Google & Apple) ক্ষেত্রে ক্লায়েন্ট অ্যাপ Firebase SDK ব্যবহার করে মেম্বারদের সাইন-ইন করায় এবং আইডেন্টিটি টোকেন (`idToken`) সংগ্রহ করে ব্যাকএন্ড এপিআই-তে পাঠায়। ব্যাকএন্ড এই টোকেনটি ভেরিফাই করে সেশন জেনারেট করে এবং কাস্টম অ্যাক্সেস টোকেন (JWT) প্রদান করে।

---

# Architecture (আর্কিটেকচার)

### ১. ইমেইল ও পাসওয়ার্ড সাইন-আপ ফ্লো
```
[User] ──(ডাটা ইনপুট দেয়)──> [SignUpController] ──> [AuthRepo.signup()]
      │
      ├──> ব্যাকএন্ড অ্যাকাউন্ট তৈরি করে ইমেইলে ওটিপি (OTP) কোড পাঠায়
      └──> ইউজার ওটিপি দেয় ──> [AuthRepo.otpVerify()] ──> এপিআই JWT রিটার্ন করে
```

### ২. সোশ্যাল লগইন (Google & Apple) ফ্লো
```
[User] ──(সোশ্যাল বাটনে ট্যাপ করে)──> [AuthService] ──> [Google/Apple SDKs]
      │
      ├──> ইউজার অ্যাকাউন্ট সিলেক্ট করে এবং SDK থেকে idToken সংগ্রহ করে
      ├──> অ্যাপলের ক্ষেত্রে সিকিউরিটি Nonce মেকানিজম সম্পন্ন করে
      ├──> /api/v1/auth/social-login এন্ডপয়েন্টে রিকোয়েস্ট পাঠায়
      ├──> ব্যাকএন্ড টোকেন সিগনেচার যাচাই করে অ্যাকাউন্ট তৈরি/লগইন করায়
      └──> রেসপন্সে সেশন টোকেন (AccessToken + RefreshToken) অ্যাপে ব্যাক করে
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/auth_service.dart` - গ্লোবাল অথেন্টিকেশন লাইফসাইকেল কন্ট্রোলার যা গুগল/অ্যাপল লগইন হ্যান্ডেল করে।
*   `lib/data/repositories/auth_repository.dart` - এপিআই ক্লায়েন্ট ব্যবহার করে নেটওয়ার্ক রিকোয়েস্ট পাঠানোর রেপো ক্লাস।
*   `lib/presentation/controllers/login_controller.dart` - ভিউ পেজ ও লগইন লজিকের মধ্যস্থতাকারী কন্ট্রোলার।
*   `lib/presentation/controllers/sign_up_controller.dart` - রেজিস্ট্রেশন পেজের ডাটা ভ্যালিডেশন ও সাবমিশন কন্ট্রোলার।
*   `lib/config/constants/api_constants.dart` - অ্যাপের সকল অথেন্টিকেশন রাউটের এপিআই পাথ সংজ্ঞায়িত করে।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  firebase_auth: ^6.1.4
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.1
  get: ^4.7.3
```

---

# Firebase Configuration (Firebase কনফিগারেশন)
Firebase Auth সেটিংস প্যানেলে সোশ্যাল প্রোভাইডার ইনেবল করতে হবে:
1. Firebase Console-এ গিয়ে **Authentication** সেকশন ওপেন করুন।
2. **Sign-in method** ট্যাবে যান।
3. **Google** এবং **Apple** প্রোভাইডার দুটি ইনেবল (Enable) করুন।
4. প্রোজেক্টের সাপোর্ট ইমেইল সেট করে সেভ করুন।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Firebase Account:** প্রোভাইডার সেটিংস কনফিগার করতে অ্যাডমিন এক্সেস প্রয়োজন।
*   **Apple Developer Portal:** অ্যাপল সাইন-ইন সার্টিফিকেট এবং প্রাইভেট কি জেনারেট করার জন্য পেইড মেম্বারশিপ অ্যাকাউন্ট প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
*   **Bearer Token (Access Token):** SharedPreferences-এ `bearerToken` কি-তে লোকাল ক্যাশ হিসেবে জমা থাকে। এটি এপিআই রিকোয়েস্ট হেডারে সংযুক্ত করা হয়।
*   **Refresh Token:** SharedPreferences-এ `refreshToken` কি-তে জমা থাকে। টোকেন এক্সপায়ার হলে এপিআই ক্লায়েন্ট এটি দিয়ে নতুন অ্যাক্সেস টোকেন জেনারেট করে।
*   **User ID:** প্রোফাইল রেসপন্স থেকে রিড করে SharedPreferences-এ `userId` কি-তে সেভ করা হয়। এটি পেমেন্ট বাইন্ডিং ভেরিফিকেশনে অত্যন্ত গুরুত্বপূর্ণ।

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

### ইমেইল রেজিস্ট্রেশন ও লগইন
1. **Signup ট্রিগার করা:**
   ```dart
   final response = await _authRepo.signup(
     name: name,
     email: email,
     password: password,
     phone: phone,
     country: country,
   );
   ```
2. **OTP ভেরিফাই করা:**
   ```dart
   final response = await _authRepo.otpVerify(email: email, otp: otp);
   if (response.statusCode == 200) {
     await _handleAuthResponse(response); // টোকেন লোকাল স্টোরেজে সেভ করার জন্য
   }
   ```
3. **লগইন ট্রিগার করা:**
   ```dart
   final response = await _authRepo.login(
     email: email,
     password: password,
     deviceToken: fcmToken,
   );
   await _handleAuthResponse(response);
   ```

---

# Backend Requirements (ব্যাকএন্ডের প্রয়োজনীয়তা)

### ১. অথেন্টিকেশন রাউটসমূহ
*   `POST /api/v1/users` - ইউজার অ্যাকাউন্ট ডেটা সেভ করা এবং ওটিপি কোড সম্বলিত ইমেইল ডিসপ্যাচ করা।
*   `POST /api/v1/auth/verify-otp` - ওটিপি মেলানো এবং ম্যাচ করলে JWT সেশন টোকেন রিটার্ন করা।
*   `POST /api/v1/auth/login` - পাসওয়ার্ড হ্যাশ যাচাই করা, পুশ নোটিফিকেশনের জন্য `deviceToken` সিঙ্ক করা এবং সেশন জেনারেট করা।
*   `POST /api/v1/auth/social-login` - গুগল/অ্যাপল টোকেন সিগনেচার যাচাই করা এবং ডেটাবেজে মেম্বার রেকর্ড তৈরি/আপডেট করা।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: রেজিস্ট্রেশন ও ওটিপি ভেরিফিকেশন
*   **ধাপ:** রেজিস্ট্রেশন ফর্মে নতুন ডাটা সাবমিট করুন, মেইলে আসা ওটিপি পেস্ট করুন এবং কনফার্ম করুন।
*   **প্রত্যাশিত ফলাফল:** ওটিপি সাবমিট করার পর অ্যাপটি টোকেন সেভ করে সরাসরি হোম পেজে নেভিগেট করবে।

### টেস্ট কেস ২: অটো লগইন সেশন যাচাই
*   **ধাপ:** লগইন থাকা অবস্থায় অ্যাপটি সম্পূর্ণ বন্ধ করে পুনরায় চালু করুন।
*   **প্রত্যাশিত ফলাফল:** `AuthService._checkLoginStatus()` মেথড মেমরি থেকে আগের টোকেন খুঁজে পাবে, `isLoggedIn.value = true` সেট করবে এবং লগইন পেজ না দেখিয়ে সরাসরি হোম পেজে নিয়ে যাবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `401 Unauthorized` | লোকাল JWT টোকেনের মেয়াদ শেষ | নেটওয়ার্ক ক্লায়েন্ট অটো-রিফ্রেশ মেথড কল করবে; রিফ্রেশ টোকেনও এক্সপায়ার হলে ইউজারকে পুনরায় লগইন পেজে রিডাইরেক্ট করবে। |
| `OTP Expired` | ওটিপি ভেরিফিকেশনে অতিরিক্ত সময় লেগেছে | `resendOtp` এন্ডপয়েন্ট ব্যবহার করে পুনরায় নতুন ওটিপি কোড রিকোয়েস্ট করুন। |
| `User ID is null` | প্রোফাইল ডাটা সফলভাবে ক্যাশ করা হয়নি | প্রোফাইল এপিআই `/users/profile` পুনরায় কল করে প্রাপ্ত আইডি `AuthService.saveUserId()` দিয়ে সেভ করুন। |

---

# Production Deployment (প্রোডাকশন ডেপ্লয়মেন্ট)
*   নিশ্চিত করুন যে অ্যাপে লাইভ এপিআই ইউআরএল (`https://api.smrtscrub.app/api/v1`) কনফিগার করা হয়েছে।
*   আইওএস ও অ্যান্ড্রয়েড কনফিগারেশনে ইন-সিকিউর নন-এইচটিটিপিএস (HTTP) কমিউনিকেশন ডিজেবল করে দিন।

---

# Troubleshooting (ডিবাগিং গাইড)
*   ডিবাগিং বা সেশন রিস্টার্ট করতে চাইলে অ্যাপটি আনইনস্টল করে আবার ইনস্টল করুন অথবা ডিভাইস সেটিংস থেকে ক্যাশ ডাটা ক্লিয়ার করে দিন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   অ্যাপের সেশন স্টেট রিয়াক্টিভ observables দিয়ে পরিচালিত হয়। `isLoggedIn` এর মান পরিবর্তিত হলে ইউআই ইন্টারফেস সাথে সাথে রিবিল্ড হবে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `pubspec.yaml` ফাইলে `firebase_auth` এবং `get` প্যাকেজ যুক্ত করুন।
2. রিপোজিটরি ক্লাসের ভেতর প্রয়োজনীয় রিকোয়েস্ট পাথ মেথডগুলো লিখে নিন।
3. `AuthService` তৈরি করে SharedPreferences-এ সেশন ডাটা সেভ, রিড ও ক্লিয়ার করার মেথড লিখুন।
4. নেটওয়ার্ক ইন্টারসেপ্টর তৈরি করে রিকোয়েস্ট হেডারে টোকেন ইনজেক্ট করার সিস্টেম কনফিগার করুন।

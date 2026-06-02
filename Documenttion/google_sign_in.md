# Google Sign-In Implementation Guide (গুগল সাইন-ইন গাইড)

এই ফাইলে ফ্লাটার অ্যাপে গুগল সাইন-ইন (Google Sign-In) ইন্টিগ্রেশন এবং ব্যাকএন্ড এপিআই ভেরিফিকেশন সেটআপ সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।

---

# Overview (পরিচিতি)
গুগল সাইন-ইন ইউজারদের ওয়ান-ট্যাপে দ্রুত সাইন-ইন করার সুবিধা প্রদান করে। ক্লায়েন্ট অ্যাপ্লিকেশন Google Sign-In SDK ব্যবহার করে ইউজারের আইডেন্টিটি টোকেন (`idToken`) সংগ্রহ করে এবং তা কাস্টম এপিআই সার্ভারে পাঠায়। ব্যাকএন্ড এই টোকেনটি যাচাই করে নতুন ইউজার হলে ডেটাবেজে রেজিস্টার করে এবং সেশন অ্যাক্সেস টোকেন (JWT) প্রদান করে।

---

# Architecture (আর্কিটেকচার)
```
[User] ──(Google বাটনে ট্যাপ করে)──> [GoogleSignIn SDK]
                                           │
                                           ├──> ডিভাইসের জিমেইল অ্যাকাউন্ট সিলেক্ট করার অপশন দেখায়
                                           ├──> গুগল আইডেন্টিটি টোকেন (idToken) সংগ্রহ করে
                                           └──> [AuthService.signInWithGoogle()]
                                                    │
                                                    └──> /auth/social-login এ পোস্ট রিকোয়েস্ট পাঠায়
                                                         (বডি: provider: 'google', idToken, deviceToken)
```

---

# Project Files (প্রজেক্ট ফাইলসমূহ)
*   `lib/core/services/auth_service.dart` - গুগল এসডিকে রান করা এবং টোকেন সংগ্রহ করে রিপোজিটরি কল করার ফাইল।
*   `lib/data/repositories/auth_repository.dart` - সোশ্যাল লগইনের জন্য `socialLogin()` এপিআই মেথড ধারণকারী ফাইল।
*   `android/app/build.gradle.kts` - অ্যান্ড্রয়েড প্রজেক্ট বিল্ড সেটিংস ফাইল।
*   `ios/Runner/Info.plist` - আইওএস রিডাইরেক্ট ইউআরএল স্কিম কনফিগারেশন ফাইল।

---

# Dependencies (ডিপেন্ডেন্সি)
```yaml
dependencies:
  google_sign_in: ^6.2.1
  get: ^4.7.3
```
*   `google_sign_in`: গুগল সাইন-ইন ফিচার যুক্ত করার জন্য অফিসিয়াল ফ্লাটার প্যাকেজ।

---

# Firebase Configuration (Firebase কনফিগারেশন)
1. **Firebase Console** ওপেন করুন।
2. **Authentication → Sign-in method** ট্যাবে যান।
3. **Google** প্রোভাইডারটি ইনেবল করুন।
4. প্রজেক্টের সাপোর্ট ইমেইল দিন এবং সেভ করুন। এর ফলে গুগল অথেন্টিকেশনের জন্য ক্লায়েন্ট আইডিগুলো প্রজেক্ট ফাইলে অটো-অ্যাসাইন হয়ে যাবে।

---

# Third Party Accounts (থার্ড পার্টি অ্যাকাউন্ট)
*   **Google Developer / Play Console Account:** গুগল প্লে স্টোরে রিলিজ করতে এবং রিলিজ কী জেনারেট করার জন্য প্রয়োজন।

---

# Credentials (ক্রেডেন্সিয়াল)
গুগল ক্লাউড প্ল্যাটফর্ম থেকে জেনারেট হওয়া ক্লায়েন্ট আইডিসমূহ:

*   **iOS Client ID:** `GoogleService-Info.plist` ফাইলের `CLIENT_ID` কি থেকে সংগ্রহ করুন।
    *   *Real Project Value:* `344458357764-l2q9u3m6an945rg6vnga1op45mhce06o.apps.googleusercontent.com`
*   **Web Client ID (serverClientId):** Firebase কনসোল থেকে প্রাপ্ত ক্লায়েন্ট আইডি যা এপিআই সার্ভারে ভেরিফিকেশনের জন্য প্রয়োজন।
    *   *Real Project Value:* `344458357764-p7cinp8ik2ogrut9g54um2nqnn0nqg9g.apps.googleusercontent.com`
*   **Android Client ID:** এটি `android/app/` ফোল্ডারের ভেতর থাকা `google-services.json` থেকে সিস্টেম অটো-রিড করে নেয়।

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

### ধাপ ১: অ্যান্ড্রয়েড SHA কী কনফিগার করা
Firebase কনসোলে আপনার অ্যান্ড্রয়েড অ্যাপ সেটিংস পেজে গিয়ে **Debug SHA-1** এবং **Release SHA-1** কী দুটি যুক্ত করুন। এরপর নতুন জেনারেট হওয়া `google-services.json` ডাউনলোড করে পুরানো ফাইলের সাথে রিপ্লেস করুন।

### ধাপ ২: আইওএস রিডাইরেক্ট স্কিম সেটিংস
আইওএস হ্যান্ডশেক সম্পন্ন করতে [Info.plist](file:///c:/Users/mdbay/StudioProjects/tbsosick/ios/Runner/Info.plist) ফাইলে Reversed Client ID ইউআরএল স্কিম যোগ করুন:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.344458357764-l2q9u3m6an945rg6vnga1op45mhce06o</string>
        </array>
    </dict>
</array>
```

### ধাপ ৩: অথেন্টিকেশন সার্ভিস কোড যুক্ত করা
`lib/core/services/auth_service.dart` ফাইলে মেথডটি লিখুন:
```dart
Future<Response?> signInWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS
          ? '344458357764-l2q9u3m6an945rg6vnga1op45mhce06o.apps.googleusercontent.com'
          : null,
      serverClientId:
          '344458357764-p7cinp8ik2ogrut9g54um2nqnn0nqg9g.apps.googleusercontent.com',
    );

    final account = await googleSignIn.signIn();
    if (account == null) return null; // ইউজার রিজেক্ট করলে null রিটার্ন হবে

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) return null;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final response = await _authRepo.socialLogin(
      provider: 'google',
      idToken: idToken,
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
      "provider": "google",
      "idToken": "eyJhbGciOiJSUzI1NiIsImtp...",
      "deviceToken": "FCM_REGISTRATION_TOKEN",
      "platform": "android"
    }
    ```
*   **ভেরিফিকেশন লজিক:** ব্যাকএন্ড সার্ভার টোকেনটি রিসিভ করে সরাসরি গুগলের ভেরিফিকেশন এপিআই (`https://oauth2.googleapis.com/tokeninfo?id_token=<idToken>`) কল করে ইউজারের আইডেন্টিটি এবং প্রজেক্ট ক্লায়েন্ট আইডি নিশ্চিত করবে।

---

# Testing Guide (টেস্টিং গাইড)

### টেস্ট কেস ১: লগইন ক্যানসেল টেস্ট
*   **ধাপ:** গুগল লগইন বাটনে ক্লিক করুন, জিমেইল লিস্ট প্যানেলটি আসলে স্ক্রিনের বাইরে ট্যাপ করে কেটে দিন।
*   **প্রত্যাশিত ফলাফল:** জিমেইল সিলেকশন প্যানেলটি বন্ধ হয়ে যাবে, অ্যাপের ফোরগ্রাউন্ডে কোনো লোডিং বা আন-রেসপন্সিভ স্ক্রিন থাকবে না।

### টেস্ট কেস ২: সফল লগইন যাচাই
*   **ধাপ:** লগইন বাটনে ক্লিক করুন, আপনার জিমেইল অ্যাকাউন্টটি সিলেক্ট করুন এবং ভেরিফিকেশন সম্পন্ন করুন।
*   **প্রত্যাশিত ফলাফল:** সাইন-ইন সম্পন্ন হবে, সার্ভার থেকে সেশন টোকেন এসে ক্যাশ হবে এবং অ্যাপটি হোম পেজে নিয়ে যাবে।

---

# Common Errors (সাধারণ সমস্যা ও সমাধান)

| Error Message (সমস্যা) | Root Cause (কারণ) | Fix (সমাধান) |
|---|---|---|
| `ApiException: 10` | অ্যাক্টিভ SHA-1 কী Firebase কনসোলে যুক্ত করা হয়নি | আপনার লোকাল কি-স্টোর থেকে SHA-1 কী-টি বের করে Firebase কনসোলের অ্যাপ সেটিংসে যুক্ত করুন। |
| `idToken is null` | `serverClientId` কনফিগারেশনে ভুল আইডি দেওয়া হয়েছে | Firebase সেটিংস থেকে **Web Client ID** কপি করে সঠিক আইডিটি কোডের `serverClientId` অপশনে পেস্ট করুন। |
| আইওএস-এ জিমেইল প্যানেল ওপেন হচ্ছে না | Reversed Client ID স্কিমটি `Info.plist`-এ সেভ করা নেই | `Info.plist` ফাইলের `CFBundleURLSchemes` ব্লকে সঠিক `REVERSED_CLIENT_ID` টাইপ নিশ্চিত করুন। |

---

# Production Deployment (প্রোডাকশন ডেপ্লয়মেন্ট)
*   রিলিজ বিল্ড বা এএবি (AAB) জেনারেট করার আগে প্লে স্টোর সাইনিং সার্টিফিকেট পেজ থেকে রিলিজ SHA-1 এবং SHA-256 কী দুটি সংগ্রহ করে Firebase কনসোলে অ্যাড করতে হবে।

---

# Troubleshooting (ডিবাগিং গাইড)
*   ডিভাইসে রিডাইরেক্ট স্ক্রিন কাজ না করলে গুগল প্লে সার্ভিসের (Google Play Services) ক্যাশ মেমরি ক্লিয়ার করে টেস্ট করুন।

---

# Knowledge Transfer Notes (ভবিষ্যৎ ডেভেলপারদের জন্য নোট)
*   আইওএস সিমুলেটরে গুগল সাইন-ইন ওয়েব ব্রাউজারের মাধ্যমে সেশন কমপ্লিট করে। রিয়েল আইওএস ডিভাইসে এটি সরাসরি নেটিভ অ্যাপ প্যানেল ওপেন করে।

---

# Reimplementation Guide (নতুন প্রজেক্টে পুনরায় ব্যবহারের গাইড)
1. `google_sign_in` ডিপেন্ডেন্সিটি যুক্ত করুন।
2. অ্যান্ড্রয়েড প্রজেক্টের SHA-1 কীটি Firebase কনসোলে অ্যাড করুন।
3. আইওএস অ্যাপের `Info.plist` ফাইলে Reversed Client ID স্কিম রেজিস্টার করুন।
4. কোডে `GoogleSignIn` ক্লাসের অবজেক্ট তৈরি করে মেইন ওটিপি ক্লায়েন্ট আইডি লিংক করুন।
5. এপিআই টোকেনটি সার্ভারের সোশ্যাল ভেরিফাই এন্ডপয়েন্টে ডিসপ্যাচ করার কোড লিখুন।

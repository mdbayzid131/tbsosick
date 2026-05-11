# In-App Purchase (IAP) — Complete Implementation Guide
## Project: SMRTSCRUB (tbsosick)
**Last Updated:** 2026-05-12 | Android ✅ End-to-End Verified | iOS ⏳ Code Ready, Store Setup Pending

---

## How It All Works Together

```
[User] taps "Subscribe Now"
        ↓
[Flutter App] calls IapService.buySubscription(product, userId)
        ↓
[IapService] generates a UUIDv5 Buyer Token from userId (security binding)
        ↓
[Google Play / App Store] shows Native Payment Sheet to the user
        ↓
[User] completes payment
        ↓
[Flutter App] receives purchase via _onPurchaseUpdate() stream listener
        ↓
[IapService] calls _verifyPurchase() → sends token to backend
        ↓
[Backend] verifies token with Google/Apple servers
        ↓
[Backend] returns 200 OK + Subscription object
        ↓
[Flutter App] calls _iap.completePurchase() to finalize
        ↓
[UI] updates to show Active subscription
```

---

# PART A — GOOGLE PLAY CONSOLE (ANDROID)

## A1. What Is Google Play Console?
Google Play Console is the developer dashboard where you manage your Android app. For IAP to work, you must:
- Upload your app at least once to an internal/closed track
- Create and activate subscription products
- Grant permissions to your backend service account

---

## A2. Uploading the App (Internal Testing Track)

### Step 1: Build a Release Bundle
Run this command in your Flutter project root:
```bash
flutter clean
flutter pub get
flutter build appbundle
```
This generates: `build/app/outputs/bundle/release/app-release.aab`

> **Important:** Every time you upload, you must increment the version code in `pubspec.yaml`:
> ```yaml
> version: 1.0.0+1   # first upload
> version: 1.0.0+2   # second upload
> version: 1.0.0+3   # third upload
> ```
> The number after `+` is the version code. Google Play rejects duplicate version codes.

### Step 2: Upload to Play Console
1. Go to [play.google.com/console](https://play.google.com/console)
2. Select your app → **Testing → Internal testing**
3. Click **"Create new release"**
4. Upload your `.aab` file
5. Add release notes (optional)
6. Click **Save → Review release → Publish**

---

## A3. Adding Internal Testers

Internal testers can install and test your app before it goes public. Without this, IAP purchases will fail.

1. Go to **Testing → Internal testing → Testers tab**
2. Click **"Manage testers"**
3. Create a new email list and add your Gmail address
4. Copy the **"Join on web"** link that appears at the bottom
5. Open that link in your phone's browser
6. Click **"Accept invite"**
7. Make sure your phone's Play Store is logged in with that same Gmail account

> **Why this matters:** Google will only process real purchases from verified testers during development.

---

## A4. Creating Subscription Products

1. Go to your app → **Monetize → Subscriptions**
2. Click **"Create subscription"**
3. Create the following 4 products:

| Product ID | Display Name | Billing Period | Price |
|---|---|---|---|
| `premium_monthly` | Premium Monthly | 1 Month | Set your price |
| `premium_yearly` | Premium Yearly | 1 Year | Set your price |
| `enterprise_monthly` | Enterprise Monthly | 1 Month | Set your price |
| `enterprise_yearly` | Enterprise Yearly | 1 Year | Set your price |

For each product:
- Set a **Reference name** (internal name)
- Set **Price** for at least one country
- Add a **Subscription period** (Monthly or Yearly)
- Set status to **"Active"** — Draft products will NOT appear in the app

> **Critical:** The Product IDs above must **exactly match** the IDs in your Flutter code (`IapService._productIds`). Any mismatch will cause products not to be found.

---

## A5. Setting Up License Testing (Free Test Purchases)

This allows you to test purchases without spending real money.

1. Go to the **main Play Console home page** (where all apps are listed)
2. In the left sidebar, click **Settings → License testing**
3. Add your Gmail address to the testers list
4. Set **License response** to **"RESPOND_NORMALLY"**
5. Click **Save**

When you now make a purchase in the app, the payment sheet will show **"Test card, always approves"** — tap it to complete a free test purchase.

---

## A6. Granting Backend Permissions (Service Account)

Your backend server needs special permission to verify purchases with Google's API. This is done by adding the backend's service account email to your Play Console.

### Who can do this?
**Only the Account Owner** of the Play Console. Admins cannot access this section.

### Steps:
1. Go to **Users and permissions** in the left sidebar
2. Click **"Invite new users"**
3. Enter the service account email:
   `play-billing-service@[ PROJECT-ID ].iam.gserviceaccount.com`
4. Click the **"Account permissions"** tab (not App permissions)
5. Check the following boxes:
   - ✅ **View financial data, orders, and cancellation survey responses**
   - ✅ **Manage orders and subscriptions**
   - ✅ **View app information and download bulk reports (read-only)**
6. Click **"Invite user"**

> **Note:** After granting permissions, it can take 5–30 minutes for Google to propagate the changes. If you still get `insufficient permissions`, wait and retry.

---

## A7. Linking Google Cloud Project to Play Console

This connects your backend's Google Cloud project to your Play Console account so the service account can access subscription data.

**Only the Account Owner can do this.**

1. Go to your app in Play Console
2. In the left sidebar, scroll down to **Setup → API access**
3. Click **"Choose a Google Cloud project to link"**
4. Select the project: **`[ PROJECT-ID ]`**
5. Click **"Link project"**

After linking, you should see the service account email listed under "Service accounts" on that same page.

---

# PART B — GOOGLE CLOUD CONSOLE

## B1. What Is Google Cloud Console?
Google Cloud Console hosts your backend infrastructure including APIs and service accounts. For IAP verification, one specific API must be enabled.

---

## B2. Enabling the Google Play Android Developer API

1. Go to [console.cloud.google.com](https://console.cloud.google.com/)
2. In the top dropdown, select project: **`[ PROJECT-ID ]`**
3. In the left sidebar go to **APIs & Services → Library**
4. In the search bar, type: **"Google Play Android Developer API"**
5. Click on it → Click **"Enable"**

> **Why this matters:** Without this API enabled, your backend cannot make any calls to Google's subscription verification endpoint, even if the service account has all the right permissions.

---

## B3. Generating a New Service Account JSON Key

If the existing key stops working (invalid JWT signature error), generate a fresh one:

1. Go to [console.cloud.google.com](https://console.cloud.google.com/)
2. Select project: `[ PROJECT-ID ]`
3. Left sidebar → **IAM & Admin → Service Accounts**
4. Find: `play-billing-service@[ PROJECT-ID ].iam.gserviceaccount.com`
5. Click on it → Go to **"Keys"** tab
6. Click **"Add Key" → "Create new key"**
7. Select **JSON** → Click **"Create"**
8. A `.json` file downloads automatically — give this to your backend developer

> **Security Warning:** This file gives full access to your Google Cloud project. Never commit it to GitHub or share it publicly. Only give it to your backend developer to place on the server.

---

# PART C — APPLE APP STORE (iOS)

## C1. What Is App Store Connect?
App Store Connect is Apple's equivalent of Google Play Console. It's where you manage your iOS app, create subscription products, and set up testing.

---

## C2. Creating a Subscription Group

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com/)
2. Select your app
3. Go to **Monetization → Subscriptions**
4. Click **"Create"** to create a Subscription Group
5. Name it something like: **"SMRTSCRUB Subscriptions"**

---

## C3. Adding Subscription Products

Inside your Subscription Group, add the following 4 products by clicking **"+"**: 

| Product ID | Reference Name | Duration |
|---|---|---|
| `premium_monthly` | Premium Monthly | 1 Month |
| `premium_yearly` | Premium Yearly | 1 Year |
| `enterprise_monthly` | Enterprise Monthly | 1 Month |
| `enterprise_yearly` | Enterprise Yearly | 1 Year |

For each product:
1. Enter the **Product ID** (must match Flutter code exactly)
2. Set **Subscription Duration**
3. Add **Subscription Prices** (at least one territory)
4. Add **Localization** → English → Add Display Name and Description
5. Status must be: **"Ready to Submit"**

---

## C4. Creating a Sandbox Tester (Free Test Purchases on iOS)

1. App Store Connect → **Users and Access → Sandbox → Testers**
2. Click **"+"**
3. Fill in any fake details (fake name, fake email like `test@example.com`, and a fake password)
4. Click **"Save"**

On your iPhone:
1. Go to **Settings → App Store**
2. Scroll to the bottom → **"Sandbox Account"**
3. Sign in with the sandbox tester credentials you just created

> When testing in-app purchases, always use this sandbox account, not your real Apple ID.

---

## C5. Uploading to TestFlight

TestFlight is Apple's internal testing platform (equivalent to Play Console's Internal Testing track).

```bash
flutter build ipa
```

1. Open **Xcode** → Window → Organizer → Click **"Distribute App"**
   OR use the **Transporter** app from the Mac App Store
2. Upload the `.ipa` to App Store Connect
3. Go to App Store Connect → **TestFlight** tab
4. Add yourself as an **Internal Tester**
5. Install the app via the TestFlight app on your iPhone

---

# PART D — BACKEND

## D1. What the Backend Does

The Flutter app sends the raw purchase token to the backend. The backend then:
1. Verifies the token with Google/Apple's servers using the service account credentials
2. Stores the subscription record in the database
3. Returns a success response to Flutter

This server-side verification is critical for security — it prevents users from faking purchases.

---

## D2. API Endpoints Used by Flutter

| Endpoint | Method | Called When |
|---|---|---|
| `/api/v1/subscriptions/google/verify` | POST | Android purchase completes |
| `/api/v1/subscriptions/apple/verify` | POST | iOS purchase completes |
| `/api/v1/subscriptions/me` | GET | Checking user's current plan |
| `/api/v1/users/profile` | GET | Getting user profile + ID |

All endpoints require `Authorization: Bearer <JWT>` header.

---

## D3. Android Verification Request (sent by Flutter)
```json
POST /api/v1/subscriptions/google/verify
{
  "purchaseToken": "cakmjihibdn...AO-J1Oz...",
  "productId": "enterprise_monthly"
}
```

## D4. iOS Verification Request (sent by Flutter)
```json
POST /api/v1/subscriptions/apple/verify
{
  "signedTransactionInfo": "eyJhbGciOiJFUzI1NiIsIng1YyI..."
}
```

## D5. Successful Verification Response
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Google subscription verified successfully",
  "data": {
    "id": "6a023b81e55bc08e2fa525fc",
    "userId": "69fa359a3fc3858c40265443",
    "plan": "ENTERPRISE",
    "platform": "google",
    "productId": "enterprise_monthly",
    "status": "active",
    "autoRenewing": true,
    "environment": "sandbox",
    "googleOrderId": "GPA.3322-3688-1106-35608",
    "startedAt": "2026-05-11T20:26:35.234Z",
    "currentPeriodEnd": "2026-05-11T20:31:34.721Z"
  }
}
```

---

## D6. Backend Configuration Required

The backend developer must configure:
1. `google-service-account.json` placed in `secrets/` folder on the server
2. Environment variable `GOOGLE_PACKAGE_NAME=com.tbsosick.smrtscrub`
3. Apple shared secret for iOS verification
4. The verify endpoints must use `subscriptionsv2` API (not the old `subscriptions` API)

---

# PART E — FLUTTER PROJECT

## E1. Files Modified/Created

| File | What Was Done |
|---|---|
| `lib/core/services/iap_service.dart` | Main IAP service — all purchase logic |
| `lib/core/bindings/initial_binding.dart` | Registered IapService globally |
| `lib/config/constants/api_constants.dart` | Added subscription API URLs |
| `lib/presentation/screens/ProfilePage/controller/subscription_controller.dart` | UI state + subscribe action |
| `lib/presentation/screens/ProfilePage/view/subscription_screen.dart` | Dynamic pricing from store |
| `lib/presentation/screens/ProfilePage/controller/profile_controller.dart` | Saves userId when profile loads |
| `lib/core/services/auth_service.dart` | Added `saveUserId()` helper method |

---

## E2. IapService — Full Code Reference

```dart
class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isLoading = false.obs;

  // Product IDs — must match exactly what's in Play Console / App Store Connect
  static const String premiumMonthly = 'premium_monthly';
  static const String premiumYearly = 'premium_yearly';
  static const String enterpriseMonthly = 'enterprise_monthly';
  static const String enterpriseYearly = 'enterprise_yearly';

  static const List<String> _productIds = [
    premiumMonthly, premiumYearly, enterpriseMonthly, enterpriseYearly,
  ];

  // SECURITY: Buyer Binding Namespace — NEVER change this value
  // Changing this will break the purchase link for all existing users
  static const String _iapNamespace = 'b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32';

  @override
  void onInit() {
    super.onInit();
    // Listen to all purchase updates (from any session)
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => AppLogger.debug('IAP Error: $error'),
    );
    initialize();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  // Step 1: Check if store is available, then fetch products
  Future<void> initialize() async {
    final bool available = await _iap.isAvailable();
    if (!available) return; // Emulators will return false here
    await fetchProducts();
  }

  // Step 2: Fetch products from the store
  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_productIds.toSet());
      // If Found: 4, Not Found: [] — all products loaded successfully
      products.assignAll(response.productDetails);
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Generate a deterministic UUIDv5 token from userId
  // This cryptographically binds each purchase to a specific user
  String deriveIapAccountToken(String userId) {
    return const Uuid().v5(_iapNamespace, userId);
  }

  // Step 4: Initiate the purchase flow
  Future<void> buySubscription(ProductDetails product, String userId) async {
    final String accountToken = deriveIapAccountToken(userId);

    late PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        applicationUserName: accountToken, // becomes obfuscatedAccountId
      );
    } else {
      purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: accountToken,
      );
    }
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Step 5: Handle all purchase status updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show loading UI. Do NOT call verify yet.
      } else if (purchase.status == PurchaseStatus.error) {
        // Always complete even on error to clear the queue
        _iap.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Only verify on these two statuses
        _verifyPurchase(purchase);
      }
    }
  }

  // Step 6: Send purchase data to backend for verification
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      final apiClient = Get.find<ApiClient>();
      dynamic response;

      if (Platform.isIOS) {
        response = await apiClient.postData(
          '${ApiConstants.subscriptionBaseUrl}/apple/verify',
          {'signedTransactionInfo': purchase.verificationData.serverVerificationData},
        );
      } else if (Platform.isAndroid) {
        response = await apiClient.postData(
          '${ApiConstants.subscriptionBaseUrl}/google/verify',
          {
            'purchaseToken': purchase.verificationData.serverVerificationData,
            'productId': purchase.productID,
          },
        );
      }

      if (response != null && response.statusCode == 200) {
        // CRITICAL: Must call completePurchase() or the purchase will loop forever
        await _iap.completePurchase(purchase);
        // TODO: Refresh user subscription status in UI
      }
    } catch (e) {
      AppLogger.debug('Error verifying purchase: $e');
    }
  }

  // Allow restoring previous purchases (required by App Store guidelines)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
```

---

## E3. SubscriptionController — Full Code Reference

```dart
class SubscriptionController extends GetxController {
  final IapService _iapService = Get.find<IapService>();

  final RxInt selectedPlan = 1.obs;           // 0=Free, 1=Premium, 2=Enterprise
  final Rx<ProductDetails?> premiumProduct = Rx<ProductDetails?>(null);
  final Rx<ProductDetails?> enterpriseProduct = Rx<ProductDetails?>(null);

  @override
  void onInit() {
    super.onInit();
    _mapProducts();
  }

  void _mapProducts() {
    // Map products that are already loaded
    _updateLocalProducts(_iapService.products);
    // Also react to future product list updates
    ever(_iapService.products, _updateLocalProducts);
  }

  void _updateLocalProducts(List<ProductDetails> products) {
    for (var product in products) {
      if (product.id == IapService.premiumMonthly) {
        premiumProduct.value = product;
      } else if (product.id == IapService.enterpriseMonthly) {
        enterpriseProduct.value = product;
      }
    }
  }

  void selectPlan(int index) => selectedPlan.value = index;

  Future<void> subscribe() async {
    // Get userId from local storage (saved when profile loads)
    final String userId = await StorageService.getString(StorageConstants.userId);
    if (userId.isEmpty) {
      Get.snackbar('Error', 'Please log in to subscribe');
      return;
    }

    ProductDetails? product;
    if (selectedPlan.value == 1) product = premiumProduct.value;
    else if (selectedPlan.value == 2) product = enterpriseProduct.value;

    if (product != null) {
      await _iapService.buySubscription(product, userId);
    } else if (selectedPlan.value != 0) {
      Get.snackbar('Error', 'Product not available in store');
    }
  }
}
```

---

## E4. UserId Storage — Why and How

**Problem:** When a user taps "Subscribe Now", the app needs to know who is buying. The `userId` must be stored locally so IapService can access it without an extra network call.

**Solution:** When the user's profile is fetched, save their ID to local storage.

```dart
// In profile_controller.dart
Future<void> getProfileData() async {
  final response = await _userDataRepository.getProfile();
  if (response.statusCode == 200) {
    final profileData = response.data['data'];
    user.value = UserModel.fromJson(profileData);

    // Save userId for IAP buyer binding
    if (profileData['id'] != null) {
      Get.find<AuthService>().saveUserId(profileData['id'].toString());
    }
  }
}

// In auth_service.dart
Future<void> saveUserId(String id) async {
  await StorageService.setString(StorageConstants.userId, id);
}
```

**API Response Structure (for reference):**
```json
GET /users/profile
{
  "data": {
    "id": "69fa359a3fc3858c40265443",   ← this is what we save
    "name": "John Doe",
    "email": "user@example.com"
  }
}
```

---

## E5. API Constants

```dart
// lib/config/constants/api_constants.dart
static const String subscriptionBaseUrl = '$baseUrl/subscriptions';

// Full URLs used in IapService:
// Android: $subscriptionBaseUrl/google/verify
// iOS:     $subscriptionBaseUrl/apple/verify
// Status:  $subscriptionBaseUrl/me  (GET)
```

---

## E6. Initial Binding (Global Registration)

```dart
// lib/core/bindings/initial_binding.dart
Get.put(IapService(), permanent: true);
// permanent: true — keeps the service alive for the entire app lifetime
// This means the purchase stream listener is always active
```

---

## E7. Build Commands

```bash
# Android — Release Bundle for Play Store
flutter clean && flutter pub get
flutter build appbundle
# Output: build/app/outputs/bundle/release/app-release.aab

# iOS — Release Archive for App Store
flutter build ipa
# Output: build/ios/ipa/Runner.ipa
```

---

## E8. Gradle Memory Fix

If you get "Gradle Daemon disappeared" during build:

**android/gradle.properties:**
```properties
# Reduced from -Xmx8G to -Xmx4G to prevent crash on low-RAM machines
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
```

---

# PART F — TROUBLESHOOTING GUIDE

## F1. Complete Error Reference

### `Store not available`
- **Cause:** App is running on an emulator or simulator
- **Fix:** Use a real physical device. IAP never works on emulators.

### `IAP: Fetch result - Found: 0, Not Found: [all 4 ids]`
- **Cause:** Products don't exist in Play Console / App Store Connect, or they're in Draft status, or the app hasn't been uploaded yet
- **Fix:**
  1. Make sure products are created in the console with the exact same IDs
  2. Make sure product status is "Active" (not Draft)
  3. Make sure your app has been uploaded to Internal Testing at least once

### `The item you were attempting to purchase could not be found`
- **Cause:** Your test account hasn't accepted the Internal Testing invite, OR your Google Play account isn't a registered tester
- **Fix:**
  1. Go to the "Join on web" link in Play Console → Internal testing → Testers
  2. Accept the invite from your test Gmail account

### `IAP: Error - User ID is empty`
- **Cause:** The userId was never saved to local storage. This happens if the user has never visited the Profile page after the code was updated, or if they never logged out and back in.
- **Fix:**
  1. Go to the Profile page once so `getProfileData()` runs and saves the userId
  2. Or: Log out and log back in

### `Google purchase verification failed: insufficient permissions`
- **Cause:** The service account email doesn't have the right permissions in Play Console, OR the Google Cloud project is not linked to the Play Console
- **Fix:**
  1. Play Console → Users and permissions → Edit service account → Account permissions → Check "View financial data" and "Manage orders"
  2. Play Console → Setup → API access → Link your Google Cloud project
  3. Wait 10–30 minutes for permissions to propagate

### `invalid_grant: Invalid JWT Signature`
- **Cause:** The service account JSON key file is corrupted, outdated, or was manually edited
- **Fix:** Generate a brand new JSON key from Google Cloud Console → IAM & Admin → Service Accounts → Keys → Add Key → Create new key → JSON

### `Version code X has already been used`
- **Cause:** You uploaded a build with the same version code as a previous upload
- **Fix:** Increment the version code in `pubspec.yaml` before every new build
  ```yaml
  version: 1.0.0+3  # change the number after +
  ```

### `Gradle Daemon disappeared unexpectedly`
- **Cause:** The build process ran out of memory (RAM)
- **Fix:** In `android/gradle.properties`, reduce max memory:
  ```properties
  org.gradle.jvmargs=-Xmx4G
  ```
  Also close heavy applications (browsers, Android Studio) during the build.

---

# PART G — MASTER CHECKLIST

## G1. Android — Status

| Task | Status |
|---|---|
| Add `in_app_purchase` package | ✅ Done |
| Create `IapService` with Buyer Binding | ✅ Done |
| Register `IapService` in `InitialBinding` | ✅ Done |
| Add subscription API URLs to `ApiConstants` | ✅ Done |
| Build and upload app to Internal Testing | ✅ Done |
| Accept Internal Testing invite on device | ✅ Done |
| Create 4 subscription products in Play Console | ✅ Done |
| Activate all products (not Draft) | ✅ Done |
| Add service account to Users and permissions | ✅ Done |
| Grant Financial Data + Manage Orders permissions | ✅ Done |
| Enable Google Play Android Developer API in Cloud | ✅ Done |
| Link Google Cloud project to Play Console | ✅ Done |
| Save userId when profile loads | ✅ Done |
| Dynamic pricing shown in Subscription UI | ✅ Done |
| **End-to-end purchase + verification test** | ✅ **PASSED** |

## G2. iOS — Pending Tasks

| Task | Status |
|---|---|
| iOS purchase code in `IapService` (Platform.isIOS branch) | ✅ Code Ready |
| iOS verify sends `signedTransactionInfo` to backend | ✅ Code Ready |
| Create Subscription Group in App Store Connect | ⏳ Pending |
| Create 4 subscription products in App Store Connect | ⏳ Pending |
| Set all iOS product status to "Ready to Submit" | ⏳ Pending |
| Create Sandbox Tester account | ⏳ Pending |
| Build and upload to TestFlight | ⏳ Pending |
| Accept TestFlight invite on iPhone | ⏳ Pending |
| Configure backend Apple verification (shared secret) | ⏳ Pending |
| End-to-end iOS purchase test | ⏳ Pending |

## G3. Upcoming Feature Work

| Task | Priority |
|---|---|
| Show "Active" badge on profile after successful purchase | High |
| Call `GET /subscriptions/me` on app launch to refresh status | High |
| Handle `409 Conflict` — receipt already used by another account | Medium |
| Handle `429 Too Many Requests` — rate limit on verify endpoint | Medium |
| Add "Restore Purchases" button (required by App Store guidelines) | Medium |
| Show subscription expiry date in profile | Low |
| Handle subscription cancellation flow in UI | Low |

---

# PART H — VERIFIED TEST RESULT

```
Date:          2026-05-12
Platform:      Android
Device:        Real Physical Device (OnePlus)
Track:         Internal Testing (Sandbox environment)
Test Type:     License Test (no real payment)

Purchase:
  Product ID:  enterprise_monthly
  Order ID:    GPA.3322-3688-1106-35608

Backend Response:
  Status:      200 OK ✅
  Message:     Google subscription verified successfully
  Plan:        ENTERPRISE
  Status:      active
  AutoRenew:   true
  Environment: sandbox
```

---

## Quick Reference — Key Values

| Item | Value |
|---|---|
| IAP Namespace (Buyer Binding) | `b9f6a4c0-1d2e-4f3a-9c8b-0e7d6c5b4a32` |
| Android Package Name | `com.tbsosick.smrtscrub` |
| Service Account Email | `play-billing-service@[ PROJECT-ID ].iam.gserviceaccount.com` |
| Google Cloud Project | `[ PROJECT-ID ]` |
| Android Verify URL | `/api/v1/subscriptions/google/verify` |
| iOS Verify URL | `/api/v1/subscriptions/apple/verify` |
| Subscription Status URL | `/api/v1/subscriptions/me` |
| User Profile URL | `/api/v1/users/profile` |

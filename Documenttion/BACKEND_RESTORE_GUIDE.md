# Backend In-App Purchase Verification & Restore Guide (Solving 409 Conflict)

This guide documents the root cause of the `409 Conflict` error during the **"Restore Purchases"** flow on Android (Google Play) and iOS (Apple App Store) and how to resolve it on the backend.

---

## 🛑 The Problem: 409 Conflict Error

### Real Request Example (From Client Logs)
```text
POST https://api.smrtscrub.app/api/v1/subscriptions/google/verify
Headers: {Content-Type: application/json, Authorization: Bearer <token>}
Body: {
  "platform": "android",
  "productId": "smrtscrub_subscription",
  "selectedBasePlanId": "",
  "purchaseToken": "ippbjanpciobbhgjblkmlpop.AO-J1Ox3SD6dBcb8saXZhy6y5f_Rlmf7vBU879RUKLqXMor2S7p0IFJmqwkdwN6pg9r974AkAmsGrFUAJhfxjwvxgqrjD5V1NRBH9b7MAlW4Nsz9JOv8W7c"
}
```

### Real Error Log & Stack Trace (409 Conflict)
```text
POST : https://api.smrtscrub.app/api/v1/subscriptions/google/verify
Status: 409
Data: {
  "success": false,
  "message": "Google obfuscatedAccountId does not match the authenticated user",
  "errorMessages": [
    {
      "path": "",
      "message": "Google obfuscatedAccountId does not match the authenticated user"
    }
  ],
  "stack": "Error: Google obfuscatedAccountId does not match the authenticated user\n    at /var/www/backend2/dist/app/modules/subscription/subscription.service.js:254:19\n    at Generator.next (<anonymous>)\n    at fulfilled (/var/www/backend2/dist/app/modules/subscription/subscription.service.js:5:58)\n    at process.processTicksAndRejections (node:internal/process/task_queues:104:5)"
}
```

### Why it Happens:
1. When a user buys a subscription inside the mobile app, the client generates a unique token (UUIDv5) based on their local app `userId` (e.g. `userId_A`) and passes it to Google Play / Apple as the `obfuscatedAccountId` (Android) or `appAccountToken` (iOS).
2. The receipt validation returns `obfuscatedExternalAccountId = userId_A`.
3. If the user logs out and logs in under a different account (e.g., `userId_B`) or recreates their account under a new ID, and clicks **"Restore Purchases"**, the app retrieves the restored purchase token and calls the backend `/verify` API.
4. The backend verifies the receipt with Google/Apple, which returns the original buyer ID (`userId_A`).
5. The backend compares `userId_A` (from receipt) against the current logged-in user `userId_B` (from `req.user.id`).
6. Because they do not match, the backend throws a `409 Conflict` error: *"Google obfuscatedAccountId does not match the authenticated user"*, preventing the user from restoring their purchase!

---

## 🛠️ The Solution: Purchase Transfer (Restore) Logic

To allow legitimate users to restore their purchases without opening doors to piracy, the backend should implement a **"Purchase Transfer"** flow instead of throwing a `409` conflict error.

### Verification Flow Chart:
```
[Verify Request Received]
          │
          ▼
[Decrypt receipt from Google/Apple]
          │
          ▼
[Extract original buyer ID (e.g., 'userId_A')]
          │
          ▼
Is original ID == current logged-in ID ('userId_B')?
   ├── YES ──> [Update current user status to PREMIUM] ──> Return 200 OK
   └── NO  ──> [Transfer Subscription]
                │
                ├── 1. Find the old user ('userId_A') in database
                ├── 2. Remove / Disable premium access for 'userId_A'
                ├── 3. Link the purchase token to 'userId_B'
                └── 4. Update 'userId_B' status to PREMIUM ──> Return 200 OK
```

---

## 💻 Code Example (Node.js/Express)

Here is how to modify the backend verification logic:

```javascript
app.post('/api/v1/subscriptions/google/verify', async (req, res) => {
  const { purchaseToken, productId } = req.body;
  const currentUserId = req.user.id; // Logged-in user (e.g., 'userId_B')

  try {
    // 1. Verify receipt with Google Developer API
    const googlePurchaseResult = await verifyWithGoogleAPI(purchaseToken, productId);
    
    // Extract the original app account token/ID used at purchase time
    const originalBuyerId = googlePurchaseResult.obfuscatedExternalAccountId;

    // 2. Check if the original purchaser matches the current session user
    if (originalBuyerId && originalBuyerId !== currentUserId) {
      console.log(`[RESTORE/TRANSFER] Transferring subscription from User ${originalBuyerId} to User ${currentUserId}`);

      // A. Locate the old user who originally held this subscription
      const oldUserSubscription = await Subscription.findOne({ userId: originalBuyerId });
      
      if (oldUserSubscription) {
        // B. Downgrade/Remove subscription status of the old user
        oldUserSubscription.status = 'inactive';
        oldUserSubscription.plan = 'FREE';
        await oldUserSubscription.save();
      }
    }

    // 3. Create or update the subscription for the CURRENT logged-in user
    let subscription = await Subscription.findOne({ userId: currentUserId });
    if (!subscription) {
      subscription = new Subscription({ userId: currentUserId });
    }

    subscription.plan = 'ENTERPRISE'; // or your specific plan name
    subscription.status = 'active';
    subscription.purchaseToken = purchaseToken;
    subscription.productId = productId;
    subscription.updatedAt = new Date();
    await subscription.save();

    return res.status(200).json({
      success: true,
      message: "Subscription verified and applied successfully",
      data: subscription
    });

  } catch (error) {
    console.error("Verification failed:", error);
    return res.status(500).json({
      success: false,
      message: "Verification failed"
    });
  }
});
```

### Node.js (Apple App Store / iOS Example)

For Apple App Store subscriptions, the backend verifies Apple transactions. When decoding the JWS transaction payload, extract the **`appAccountToken`** (which contains the original `userId` UUID).

```javascript
app.post('/api/v1/subscriptions/apple/verify', async (req, res) => {
  const { transactionId } = req.body;
  const currentUserId = req.user.id; // Logged-in user (e.g., 'userId_B')

  try {
    // 1. Verify and decode Apple App Store JWS transaction
    const appleTransaction = await verifyAppleTransaction(transactionId);
    
    // Extract the original app account token/ID used at purchase time
    const originalBuyerId = appleTransaction.appAccountToken; // UUID

    // 2. Check if the original purchaser matches the current session user
    if (originalBuyerId && originalBuyerId !== currentUserId) {
      console.log(`[RESTORE/TRANSFER] Transferring Apple subscription from User ${originalBuyerId} to User ${currentUserId}`);

      // A. Locate the old user who originally held this subscription
      const oldUserSubscription = await Subscription.findOne({ userId: originalBuyerId });
      
      if (oldUserSubscription) {
        // B. Downgrade/Remove subscription status of the old user
        oldUserSubscription.status = 'inactive';
        oldUserSubscription.plan = 'FREE';
        await oldUserSubscription.save();
      }
    }

    // 3. Create or update the subscription for the CURRENT logged-in user
    let subscription = await Subscription.findOne({ userId: currentUserId });
    if (!subscription) {
      subscription = new Subscription({ userId: currentUserId });
    }

    subscription.plan = 'ENTERPRISE'; // or your specific plan name
    subscription.status = 'active';
    subscription.transactionId = transactionId;
    subscription.updatedAt = new Date();
    await subscription.save();

    return res.status(200).json({
      success: true,
      message: "Apple Subscription verified and applied successfully",
      data: subscription
    });

  } catch (error) {
    console.error("Apple Verification failed:", error);
    return res.status(500).json({
      success: false,
      message: "Apple Verification failed"
    });
  }
});
```

---

### Benefits of this Logic:
1. **Resolves the 409 error:** Users can log out, change accounts, or restore purchase on any device logged into their Play Store/App Store account.
2. **Prevents Piracy:** The subscription is transferred, meaning the old account (`userId_A`) automatically loses its premium status when the new account (`userId_B`) claims it.

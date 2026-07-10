# Backend Social Authentication Guide (Google & Apple Sign-In)

This document explains the unified social authentication flow using **Firebase Authentication** on the client side and how the backend developer should verify these credentials.

---

## 🔄 Authentication Architecture

```
[Mobile App (iOS/Android)] ──(Google/Apple Sign-In)──> [Firebase Auth SDK]
                                                             │
                                                             └──> Generates Firebase ID Token (JWT)
                                                             │
[Mobile App (iOS/Android)] ──(POST /auth/social-login)──────> [Backend Server]
                                                             │
                                                             └──> Verifies Token via Firebase Admin SDK
                                                             └──> Returns App Access & Refresh Tokens
```

Instead of sending platform-specific tokens (like raw Google ID Tokens or raw Apple Identity Tokens) directly to the backend, the mobile app first authenticates with the client-side **Firebase Auth SDK**. This yields a standardized **Firebase ID Token** (JWT) which is sent to the backend.

---

## 🌐 API Request Payload

* **Endpoint:** `POST /api/v1/auth/social-login`
* **Content-Type:** `application/json`

### Google Sign-In Payload
```json
{
  "provider": "google",
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6..." // Firebase ID Token
}
```

### Apple Sign-In Payload
```json
{
  "provider": "apple",
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6..." // Firebase ID Token
}
```

---

## 🛠️ Backend Verification Code Examples

The backend must verify the `idToken` using the **Firebase Admin SDK**.

### Node.js (Express / NestJS)

1. **Install Firebase Admin SDK:**
   ```bash
   npm install firebase-admin
   ```

2. **Initialize Firebase Admin SDK:**
   Make sure you download the Service Account Private Key JSON file from the Firebase Console (Project Settings -> Service accounts) and configure it:
   ```javascript
   const admin = require('firebase-admin');
   const serviceAccount = require('./path-to-service-account-key.json');

   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });
   ```

3. **Verify the Token in your controller:**
   ```javascript
   app.post('/api/v1/auth/social-login', async (req, res) => {
     const { provider, idToken } = req.body;

     try {
       // Verify the Firebase ID Token
       const decodedToken = await admin.auth().verifyIdToken(idToken);
       
       // Decoded token contains user information
       const { uid, email, name, picture } = decodedToken;

       // 1. Find or create user in your local database using uid or email
       let user = await User.findOne({ $or: [{ firebaseUid: uid }, { email }] });
       if (!user) {
         user = new User({
           firebaseUid: uid,
           email,
           name: name || 'Social User',
           avatar: picture,
           provider
         });
       }

       await user.save();

       // 3. Generate your own app JWT (accessToken & refreshToken)
       const appAccessToken = generateAccessToken(user);
       const appRefreshToken = generateRefreshToken(user);

       return res.status(200).json({
         success: true,
         message: "Login successful",
         data: {
           token: appAccessToken,
           accessToken: appAccessToken, // Compatibility key
           refreshToken: appRefreshToken,
           user: {
             id: user._id,
             email: user.email,
             name: user.name
           }
         }
       });

     } catch (error) {
       console.error("Firebase token verification failed:", error);
       return res.status(401).json({
         success: false,
         message: "Unauthorized: Invalid token"
       });
     }
   });
   ```

---

## ⚠️ 2nd-Time Login (User Already Exists Issue) - IMPORTANT!

A very common issue in social logins is throwing a `"User already exists"` error when the user logs in for the second time. 

To prevent this:
1. **Do not use a registration-only flow.** The `/auth/social-login` endpoint is a **combined Registration + Login (Upsert)** flow.
2. When the token is verified, **first search** the database for a user with the matching `email` or `firebaseUid`.
3. **If the user exists:**
   - Immediately log them in, generate their JWT tokens (`accessToken` and `refreshToken`), and return them with a `200 OK` status.
   - **Do not** attempt to re-register them or throw a duplicate key validation error.
4. **If the user does not exist:**
   - Create and save the new user record in your database.
   - Generate their JWT tokens and return them with a `200 OK` status.

---

## ✨ Benefits of this Approach
1. **No Redirect Handlers Needed:** The mobile app handles Apple & Google redirects natively (no custom server-side OAuth callback page required).
2. **Unified Verification:** The backend code to verify Google and Apple users is exactly the same—both tokens are verified using `admin.auth().verifyIdToken(idToken)`.
3. **Improved Security:** Token validation is cryptographically verified directly through Firebase.

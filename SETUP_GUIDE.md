# DupZero — Complete Setup Guide
## Developed by Tavoo

---

## What You Need to Install First

1. **Flutter SDK** → https://flutter.dev/docs/get-started/install/windows
2. **VS Code** → https://code.visualstudio.com
3. **VS Code Extensions** → Install: Flutter + Dart (by Dart Code)
4. **Android Studio** (for Android emulator) OR plug in your Android phone via USB
5. **Node.js** → https://nodejs.org (needed for Firebase CLI)
6. **Git** → https://git-scm.com

---

## Part 1 — Run the App (Offline Mode, No Firebase Needed)

```bash
# 1. Extract the zip to a folder
# 2. Open that folder in VS Code
# 3. Open Terminal in VS Code (Ctrl + backtick)

# Get all packages
flutter pub get

# Check your connected devices
flutter devices

# Run the app
flutter run
```

That's it. The app runs completely without Firebase.
All scanning, deletion, storage alerts, recycle bin — everything works.

---

## Part 2 — Add Firebase (Enables Login + Cloud Features)

### Step 1 — Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click **"Add project"**
3. Name it: **dupzero-tavoo**
4. Disable Google Analytics (optional)
5. Click **"Create project"**

### Step 2 — Add Android App to Firebase

1. In Firebase Console → click **Android icon**
2. Package name: `com.tavoo.dupzero`
3. App nickname: **DupZero Android**
4. Click **"Register app"**
5. Download **google-services.json**
6. **Replace** the file at: `android/app/google-services.json`
   (overwrite the stub file that is already there)

### Step 3 — Add iOS App to Firebase (if you need iOS)

1. In Firebase Console → click **iOS icon**
2. Bundle ID: `com.tavoo.dupzero`
3. App nickname: **DupZero iOS**
4. Download **GoogleService-Info.plist**
5. **Replace** the file at: `ios/Runner/GoogleService-Info.plist`

### Step 4 — Enable Authentication in Firebase

1. Firebase Console → **Authentication** → **Get started**
2. **Sign-in method** tab:
   - Enable **Email/Password**
   - Enable **Google**
3. For Google sign-in → add your **Support email**
4. Save

### Step 5 — Update firebase_options.dart

**Option A — Automatic (recommended, 1 command):**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login
firebase login

# Auto-configure (overwrites firebase_options.dart automatically)
flutterfire configure --project=dupzero-tavoo
```

**Option B — Manual:**
- Open `lib/firebase_options.dart`
- Replace `YOUR_ANDROID_API_KEY` with the key from google-services.json
- Replace `YOUR_IOS_API_KEY` with the key from GoogleService-Info.plist

### Step 6 — Run with Firebase

```bash
flutter pub get
flutter run
```

Now the app has full online features:
- ✅ Email sign in / sign up
- ✅ Google sign in
- ✅ User accounts
- ✅ Cross-device sync (Pro)
- ✅ Cloud storage scanning (Pro)

---

## Part 3 — Build Release APK (to install on any Android phone)

```bash
flutter build apk --release
```

APK will be at:
`build/app/outputs/flutter-apk/app-release.apk`

Send this to anyone. They can install it directly on Android.

---

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| `flutter: command not found` | Add Flutter to PATH — see flutter.dev/docs |
| `No devices found` | Enable USB Debugging on your phone |
| `google-services.json not found` | Download from Firebase Console and put in android/app/ |
| `PigeonApiDelegate` error | Run: `flutter clean && flutter pub get` |
| `minSdk version` error | Already set to 21 in build.gradle — should not happen |
| `Gradle build failed` | Run: `cd android && ./gradlew clean` then `flutter run` |
| Firebase `app not initialized` | Check google-services.json has correct package name: `com.tavoo.dupzero` |

---

## App Information

- **App Name:** DupZero
- **Version:** 1.1.0
- **Package:** com.tavoo.dupzero
- **Developer:** Tavoo
- **Platform:** Android · iOS · Windows · macOS

---

*This guide was written specifically for Tavoo's DupZero project.*

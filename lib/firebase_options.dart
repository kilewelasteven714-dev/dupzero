// ════════════════════════════════════════════════════════
// DupZero — Firebase Configuration
// Developed by Tavoo
// ════════════════════════════════════════════════════════
//
// HOW TO GET YOUR REAL VALUES (5 minutes):
//
// OPTION A — Automatic (Recommended):
//   1. Install FlutterFire CLI:
//      dart pub global activate flutterfire_cli
//   2. Login to Firebase:
//      firebase login
//   3. Run in your project folder:
//      flutterfire configure --project=dupzero-tavoo
//   This file will be AUTOMATICALLY overwritten with real values.
//
// OPTION B — Manual:
//   1. Go to https://console.firebase.google.com
//   2. Create project: dupzero-tavoo
//   3. Add Android app → package: com.tavoo.dupzero
//   4. Add iOS app → bundle ID: com.tavoo.dupzero
//   5. Copy the API keys into the fields below
//
// ════════════════════════════════════════════════════════

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS:     return ios;
      case TargetPlatform.macOS:   return macos;
      case TargetPlatform.windows: return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for \${defaultTargetPlatform.name}. '
          'Run: flutterfire configure --project=dupzero-tavoo',
        );
    }
  }

  // ── ANDROID ─────────────────────────────────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey:            'YOUR_ANDROID_API_KEY',       // from google-services.json
    appId:             '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId:         'dupzero-tavoo',
    storageBucket:     'dupzero-tavoo.appspot.com',
  );

  // ── iOS ─────────────────────────────────────────────────
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:            'YOUR_IOS_API_KEY',            // from GoogleService-Info.plist
    appId:             '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId:         'dupzero-tavoo',
    storageBucket:     'dupzero-tavoo.appspot.com',
    iosClientId:       'YOUR_IOS_CLIENT_ID',
    iosBundleId:       'com.tavoo.dupzero',
  );

  // ── macOS ────────────────────────────────────────────────
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey:            'YOUR_MACOS_API_KEY',
    appId:             '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId:         'dupzero-tavoo',
    storageBucket:     'dupzero-tavoo.appspot.com',
    iosClientId:       'YOUR_MACOS_CLIENT_ID',
    iosBundleId:       'com.tavoo.dupzero',
  );

  // ── Windows / Web ────────────────────────────────────────
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey:            'YOUR_WEB_API_KEY',
    appId:             '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId:         'dupzero-tavoo',
    storageBucket:     'dupzero-tavoo.appspot.com',
    authDomain:        'dupzero-tavoo.firebaseapp.com',
  );

  static const FirebaseOptions web = windows;
}

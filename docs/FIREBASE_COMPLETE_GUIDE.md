# DupZero — Firebase Complete Setup Guide
## Developed by Tavoo

---

## Firebase Ni Nini?

Firebase ni huduma ya Google inayotoa:
- Authentication (login system)
- Database (Firestore)
- Storage (files)
- Push Notifications
- Analytics

Inatumia Gmail yako ya kawaida — hakuna account mpya.

---

## HATUA 1 — Fungua Firebase Project

1. Nenda: console.firebase.google.com
2. Ingia na Gmail yako
3. Click "Create a project"
4. Jina: dupzero-tavoo
5. Google Analytics: Continue → Create project
6. Subiri sekunde 30 → Continue

---

## HATUA 2 — Ongeza Android App

1. Click Android icon
2. Package name: com.tavoo.dupzero
3. App nickname: DupZero Android
4. Register app
5. Download google-services.json
6. Weka kwenye: android/app/google-services.json
7. Next → Next → Continue to console

---

## HATUA 3 — Ongeza iOS App (Optional)

1. Click iOS icon
2. Bundle ID: com.tavoo.dupzero
3. App nickname: DupZero iOS
4. Download GoogleService-Info.plist
5. Weka kwenye: ios/Runner/GoogleService-Info.plist

---

## HATUA 4 — Wezesha Authentication

1. Firebase Console → Authentication → Get started
2. Sign-in method tab:
   - Email/Password → Enable → Save
   - Google → Enable → Support email: gmail-yako → Save

---

## HATUA 5 — Wezesha Firestore

1. Firebase Console → Firestore Database → Create database
2. Start in production mode
3. Location: europe-west (karibu na Afrika)
4. Done

---

## HATUA 6 — Weka Security Rules

1. Firestore → Rules tab
2. Futa rules zilizopo
3. Copy content ya firestore.rules (ipo kwenye project)
4. Publish

---

## HATUA 7 — Update firebase_options.dart

### Option A — Automatic (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login
firebase login

# Configure (inabadilisha firebase_options.dart automatically)
flutterfire configure --project=dupzero-tavoo
```

### Option B — Manual
Fungua lib/firebase_options.dart
Badilisha YOUR_ANDROID_API_KEY na key kutoka google-services.json

---

## HATUA 8 — Run App

```bash
flutter pub get
flutter run
```

Sasa login inafanya kazi, Google Sign-In inafanya kazi!

---

## Makosa ya Firebase

| Kosa | Ufumbuzi |
|------|---------|
| App not initialized | Check google-services.json package name: com.tavoo.dupzero |
| Google Sign-In failed | Wezesha Google kwenye Authentication Console |
| Permission denied | Weka Security Rules kwenye Firestore |
| Network error | Check internet connection |

# DupZero — Google Play Store Publishing Guide
## Hatua Kamili
## Developed by Tavoo

---

## Mahitaji

- Google account (Gmail yako ya kawaida)
- $25 — ada ya mara moja tu
- Keystore (saini ya app)
- AAB file (app iliyojengwa)
- Screenshots 2+ za app
- App icon (512×512px)
- Privacy Policy URL

---

## HATUA 1 — Tengeneza Keystore

```bash
keytool -genkey -v \
  -keystore android/keystore/dupzero-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias dupzero
```

Jibu maswali:
- First and last name: Tavoo
- Organization: Tavoo Apps
- City: Dar es Salaam
- Country code: TZ
- Password: (weka yako — ikumbuke!)

⚠️ HIFADHI JKS FILE MAHALI SALAMA — UKIIPOTEZA HUWEZI KUSASISHA APP

---

## HATUA 2 — Weka key.properties

Tengeneza: android/app/key.properties
```
storePassword=PASSWORD_YAKO
keyPassword=PASSWORD_YAKO
keyAlias=dupzero
storeFile=../keystore/dupzero-release.jks
```

---

## HATUA 3 — Build AAB

```bash
flutter build appbundle --release
```

APK ipo: build/app/outputs/bundle/release/app-release.aab

---

## HATUA 4 — Fungua Play Console

1. play.google.com/console
2. Ingia na Gmail
3. Lipa $25
4. Jaza taarifa za developer

---

## HATUA 5 — Tengeneza App

1. Create app
2. App name: DupZero
3. Default language: English
4. App or game: App
5. Free or paid: Free
6. Create app

---

## HATUA 6 — Store Listing

Short description (80 herufi):
```
Find and remove duplicate files instantly. Save storage space automatically.
```

Full description (4000 herufi):
```
DupZero — Intelligent Duplicate File Cleaner

Remove duplicate files and free up storage space on your Android device.

FEATURES:
★ Duplicate Detection — SHA-256 exact matching
★ AI Similar Images — Perceptual hashing technology
★ Storage Alert — Notifies you when storage hits 70%
★ Recycle Bin — 30-day recovery for deleted files
★ Smart Suggestions — AI-powered cleanup recommendations
★ Works Offline — No internet required
★ Download Watcher — Detects duplicate downloads instantly
★ Protected Folders — Exclude important folders from scanning
★ Fast Scanning — Parallel processing with 4 CPU cores

PRO FEATURES ($2.99/month):
★ Cloud Storage Scan (Google Drive, OneDrive, iCloud)
★ Unlimited file scanning
★ Scheduled automatic cleanup
★ Cross-device sync
★ Advanced analytics

SAFE & SECURE:
★ No ads
★ No data collection
★ No tracking
★ Open source

Developed by Tavoo
```

---

## HATUA 7 — Graphics

| Kitu | Ukubwa | Jinsi ya Kupata |
|------|--------|----------------|
| App icon | 512×512 PNG | Canva.com (bure) |
| Feature graphic | 1024×500 PNG | Canva.com (bure) |
| Phone screenshots | 1080×1920 | Android Studio emulator |
| Tablet screenshot | 1600×2560 | Android Studio emulator |

### Kupiga Screenshots kwenye Emulator
1. Run app: flutter run
2. Android Studio → Device Manager → Camera icon
3. Screenshot inasavewa automatically

---

## HATUA 8 — Subscriptions

Play Console → Monetize → Products → Subscriptions

Tengeneza 3:
1. ID: dupzero_pro_monthly | $2.99 | Monthly
2. ID: dupzero_pro_yearly | $19.99 | Yearly
3. ID: dupzero_pro_lifetime | $49.99 | One-time

---

## HATUA 9 — Privacy Policy (Lazima)

1. Nenda: app-privacy-policy-generator.firebaseapp.com
2. App name: DupZero
3. Developer: Tavoo
4. Generate → Host kwenye GitHub Pages (bure)
5. Copy link → weka Play Console

---

## HATUA 10 — Content Rating

Policy → App content → Start questionnaire
DupZero → Everyone ✅

---

## HATUA 11 — Pakia na Submit

1. Release → Production → Create new release
2. Upload app-release.aab
3. Release notes:
```
DupZero v1.1.0
• Duplicate file detection with SHA-256
• AI similar image detection
• Storage alert at 70%
• Recycle Bin with 30-day recovery
• Works 100% offline
Developed by Tavoo
```
4. Save → Review release → Start rollout to production

---

## HATUA 12 — Subiri Review

Google: siku 1-7
Ukipata approval → App iko Play Store! 🎉

---

## Kupokea Pesa

1. Fungua Payoneer.com (bure)
2. Jaza taarifa + piga picha ya National ID
3. Subiri siku 1-2
4. Play Console → Payments → Add bank account → Weka Payoneer details
5. Mwisho wa kila mwezi → pesa zinakuja Payoneer
6. Toa ATM au tuma M-Pesa

<div align="center">

# ⬡ DupZero

### Intelligent Duplicate File Cleaner

**Built by Tavoo · Flutter · Clean Architecture · Production Ready**

![Version](https://img.shields.io/badge/version-1.1.0-7C6FFF)
![Flutter](https://img.shields.io/badge/Flutter-3.19-02569B)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS-lightgrey)
![Price](https://img.shields.io/badge/Pro-$2.99%2Fmonth-gold)
![Language](https://img.shields.io/badge/language-EN%20%7C%20SW-green)

</div>

---

## What is DupZero?

DupZero is a production-grade duplicate file cleaner built with Flutter.
Finds and removes duplicate files using SHA-256 and AI perceptual hashing.

**Works 100% offline. No ads. No tracking. No data selling.**

---

## Quick Start

```bash
git clone https://github.com/tavoo/dupzero.git
cd dupzero
flutter pub get
flutter run
```

---

## Features

| Feature | Free | Pro ($2.99/mo) |
|---------|------|----------------|
| Duplicate scanning | ✅ 500 files | ✅ Unlimited |
| Exact matching (SHA-256) | ✅ | ✅ |
| Recycle Bin (30 days) | ✅ | ✅ |
| Storage alert at 70% | ✅ | ✅ |
| Works offline | ✅ | ✅ |
| AI similar image detection | ❌ | ✅ |
| Cloud scan (Drive/OneDrive) | ❌ | ✅ |
| Scheduled cleanup | ❌ | ✅ |
| Cross-device sync | ❌ | ✅ |
| Advanced analytics | ❌ | ✅ |

---

## Architecture

```
lib/
├── core/           # Constants, DI, Router, Security, Services, Theme
├── domain/         # Entities, Repositories (abstract), Use Cases
├── data/           # Repository implementations, Data sources
└── presentation/   # BLoCs, Pages, Widgets
```

**Pattern:** Clean Architecture + BLoC + Repository Pattern

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| UI | Flutter + Material 3 |
| State | BLoC + Equatable |
| Navigation | GoRouter |
| Auth | Firebase Auth |
| Local DB | Hive |
| Cloud DB | Firestore |
| DI | GetIt + Injectable |
| Hashing | SHA-256 + Perceptual Hash |
| Background | WorkManager |
| Notifications | flutter_local_notifications |
| Billing | in_app_purchase |
| i18n | English + Swahili |
| Testing | flutter_test + bloc_test |

---

## Security

- Firebase Auth + Firestore Security Rules
- Root/jailbreak detection with warning
- Certificate pinning (HTTPS only)
- Screenshot prevention
- Proguard obfuscation
- No hardcoded secrets

---

## Guides

| Guide | Location |
|-------|---------|
| PC Setup (Windows) | docs/PC_GUIDE.md |
| Termux + GitHub (Phone) | docs/TERMUX_COMPLETE_GUIDE.md |
| Firebase Setup | docs/FIREBASE_COMPLETE_GUIDE.md |
| Play Store Publishing | docs/PLAY_STORE_GUIDE.md |
| App Store Publishing | docs/APP_STORE_GUIDE.md |
| Receiving Payments (Payoneer) | docs/PAYONEER_GUIDE.md |
| Privacy Policy | docs/PRIVACY_POLICY.md |
| Project History | docs/FULL_HISTORY.md |

---

## Developer

**Tavoo** (Steven Stephan Kilewela)
DIT II Student · Mzumbe University · Tanzania
Building world-class software from a phone. 🇹🇿

---

<div align="center">
<strong>⭐ Star this repo if DupZero helped you!</strong><br>
<em>First Flutter app built entirely from an Android phone using Termux</em>
</div>

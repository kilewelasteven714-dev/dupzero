# DupZero v1.1.0 — New Features Added

## Developed by Tavoo

---

## Features Added in This Update

### 1. Storage Alert at 70%  *(core new feature)*
- `StorageAlertService` monitors device storage in real time
- Fires a high-priority push notification when storage >= 70%
- Alert includes: current percentage, free space remaining, tap-to-scan action
- Color-coded: orange at 70%, red at 90% (critical)
- 12-hour cooldown so the user is not spammed
- Also runs as a background task every 6 hours (works fully offline)
- The storage bar on the Home screen changes color: green → orange → red
- Banner appears on Home screen automatically when threshold is crossed

### 2. Permanent Deletion Warning
- Every deletion now shows `PermanentDeleteDialog` — a clear, explicit warning
- Warning text states clearly: "This action CANNOT be undone"
- A permanent deletion notice also appears in the bottom action bar
- The success snackbar now reads "Permanently deleted X files"

### 3. 100% Offline-First
- All core features work with zero internet:
  - SHA-256 scanning, perceptual hash detection
  - File deletion, storage monitoring, alerts
  - Download folder real-time watching
  - Scheduled cleanup, all settings, all history
- Online is ONLY used for:
  - Cloud scanning (Google Drive / OneDrive / iCloud) — Pro only
  - Cross-device sync — Pro only
  - App updates via the OS store
- Offline badge shown on the Home screen

### 4. Real-Time Download Duplicate Detection
- `DownloadWatcherService` watches download folders continuously (offline)
- When a new file lands in Downloads / WhatsApp / Telegram / DCIM etc.,
  its hash is computed and matched against the existing file index
- If a duplicate is found, a notification fires immediately with options:
  - "Keep Both" or "Delete Download"
- Works completely offline — no internet required

### 5. Developer Credit — Tavoo
- `AppConstants.developerName = 'Tavoo'`
- `AppConstants.developerTitle = 'Developed by Tavoo'`
- Shown in Home screen footer
- Shown in Settings → About section
- Written in main.dart code comment
- Shown in app About card with version 1.1.0

---

## What Was Already There (Untouched)
- SHA-256 exact duplicate detection
- Perceptual hashing similar image detection
- Duplicate grouping by Images / Videos / Audio / Documents
- Manual file selection and deletion
- Scheduled auto-cleanup (daily / weekly / monthly)
- Cloud storage scanning scaffold
- Dark mode + 8 color themes
- Freemium + Pro monetization
- Firebase Auth (email + Google)
- All BLoCs: Auth, Scan, Cleanup, Settings, Theme
- GoRouter navigation
- All UI pages: Onboarding, Home, Scan, Duplicates, Analytics, Settings, Premium

---

## New Files Added
- `lib/core/services/storage_alert_service.dart`
- `lib/core/services/notification_service.dart` (restored + extended)
- `lib/core/services/download_watcher_service.dart`
- `lib/core/services/offline_sync_service.dart`
- `lib/presentation/blocs/storage/storage_bloc.dart`
- `lib/presentation/blocs/storage/storage_event.dart`
- `lib/presentation/blocs/storage/storage_state.dart`
- `lib/presentation/widgets/storage_alert_banner.dart`
- `lib/presentation/widgets/permanent_delete_dialog.dart`

## Modified Files
- `lib/core/constants/app_constants.dart` — new keys + developer credit
- `lib/core/di/injection.dart` — register new services and StorageBloc
- `lib/core/services/background_scan_service.dart` — adds storage check task
- `lib/main.dart` — adds StorageBloc provider
- `lib/presentation/pages/home_page.dart` — alert banner + offline badge + Tavoo credit
- `lib/presentation/pages/duplicates_page.dart` — permanent deletion dialog
- `lib/presentation/pages/settings_page.dart` — storage alert toggle + offline info + About/Tavoo
- `lib/presentation/widgets/storage_summary_card.dart` — live storage with alert colors

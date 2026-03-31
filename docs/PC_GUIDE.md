# DupZero — PC Guide (Windows + VS Code)
## Hatua Kamili kwa Hatua
## Developed by Tavoo

---

## Vitu Unavyohitaji Kudownload (Vyote Bure)

| Kitu | Tovuti | Maelezo |
|------|--------|---------|
| Flutter SDK | flutter.dev | Engine ya app |
| VS Code | code.visualstudio.com | Editor ya code |
| Git | git-scm.com | Version control |
| Android Studio | developer.android.com/studio | Android SDK + Emulator |

---

## SEHEMU 1 — Weka Flutter

### Hatua 1 — Download na Extract
1. Nenda flutter.dev/docs/get-started/install/windows
2. Download flutter_windows_3.19.0-stable.zip
3. Extract kwenye C:\flutter
4. Folder iwe: C:\flutter\bin\flutter.exe

### Hatua 2 — Ongeza PATH
1. Windows key → andika "Environment Variables"
2. Edit the system environment variables
3. Environment Variables → System variables → Path → Edit
4. New → andika: C:\flutter\bin
5. OK → OK → OK

### Hatua 3 — Thibitisha
Fungua Command Prompt:
```
flutter --version
flutter doctor
```

---

## SEHEMU 2 — Weka VS Code

### Install Extensions
1. Ctrl+Shift+X
2. Install: Flutter (by Dart Code)
3. Install: Dart (by Dart Code)
4. Install: Error Lens
5. Install: Pubspec Assist

---

## SEHEMU 3 — Android SDK

1. Fungua Android Studio
2. Setup wizard → Next → Next (inadownload SDK)
3. Device Manager → Create Device → Pixel 6 → API 34 → Finish
4. Bonyeza ▶ → virtual phone inafunguka

---

## SEHEMU 4 — Fungua DupZero

1. Extract dupzero_PERFECTION_by_Tavoo.zip → C:\Projects\dupzero
2. VS Code → File → Open Folder → C:\Projects\dupzero
3. Ctrl+` (fungua terminal)
4. Run: flutter pub get

---

## SEHEMU 5 — Run App

```bash
# Angalia devices
flutter devices

# Run app
flutter run

# Build APK
flutter build apk --release

# Build AAB (Play Store)
flutter build appbundle --release
```

---

## SEHEMU 6 — Simu ya Kweli (USB Debugging)

1. Settings → About Phone → Build Number (bonyeza mara 7)
2. Developer Options → USB Debugging → ON
3. Unganisha USB
4. Simu: Allow USB Debugging → Allow
5. flutter devices → unaona simu yako
6. flutter run → app inainstall kwenye simu

---

## Makosa ya Kawaida

| Kosa | Ufumbuzi |
|------|---------|
| flutter: command not found | Ongeza C:\\flutter\\bin kwenye PATH |
| No devices found | Wezesha USB Debugging |
| Gradle build failed | flutter clean && flutter run |
| SDK not found | Fungua Android Studio kwanza |
| Package not found | flutter pub get |
| App inacrash | flutter clean && flutter pub get && flutter run |

---

## Amri Muhimu Zote

| Amri | Matumizi |
|------|---------|
| flutter pub get | Pata packages |
| flutter run | Run app |
| flutter build apk | Tengeneza APK |
| flutter build appbundle | Tengeneza AAB (Play Store) |
| flutter build ios | Tengeneza iOS (Mac tu) |
| flutter clean | Futa build cache |
| flutter devices | Angalia devices |
| flutter doctor | Check installation |
| flutter test | Run tests |
| flutter analyze | Check code quality |

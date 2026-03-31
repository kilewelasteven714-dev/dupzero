# DupZero — Apple App Store Publishing Guide
## Hatua Kamili
## Developed by Tavoo

---

## Mahitaji (Tofauti na Play Store)

| Kitu | Bei | Lazima? |
|------|-----|---------|
| Apple Developer Account | $99/mwaka | ✅ Lazima |
| Mac computer | Tofauti | ✅ Lazima (au Codemagic) |
| Xcode | Bure | ✅ Lazima (kwenye Mac) |

---

## Kama Huna Mac — Tumia Codemagic

1. Nenda codemagic.io
2. Ingia na GitHub account
3. Connect repository ya DupZero
4. Weka Apple Developer credentials
5. Build → Codemagic inabuildia kwenye Mac yao
6. Bure: dakika 500/mwezi

---

## HATUA 1 — Apple Developer Account

1. developer.apple.com
2. Account → Enroll
3. Chagua: Individual
4. Lipa $99 kwa kadi
5. Subiri siku 1-2 (Apple wakupigie simu)

---

## HATUA 2 — App ID

1. developer.apple.com → Certificates, IDs & Profiles
2. Identifiers → + → App IDs → App
3. Bundle ID: com.tavoo.dupzero
4. Capabilities: Push Notifications ✓, In-App Purchase ✓
5. Register

---

## HATUA 3 — App Store Connect

1. appstoreconnect.apple.com
2. My Apps → + → New App
3. Name: DupZero
4. Bundle ID: com.tavoo.dupzero
5. SKU: dupzero-001

---

## HATUA 4 — Build iOS

```bash
# Kwenye Mac
flutter build ios --release
open ios/Runner.xcworkspace

# Kwenye Xcode:
# 1. Chagua Any iOS Device
# 2. Product → Archive
# 3. Distribute App → App Store Connect
# 4. Upload
```

---

## HATUA 5 — App Information

Screenshots zinahitajika kwa:
- iPhone 6.7" (1290×2796)
- iPhone 5.5" (1242×2208)
- iPad Pro 12.9" (2048×2732)

---

## HATUA 6 — In-App Purchases

App Store Connect → My Apps → DupZero → In-App Purchases

Tengeneza:
1. Auto-Renewable Subscription: DupZero Pro Monthly — $2.99
2. Auto-Renewable Subscription: DupZero Pro Yearly — $19.99
3. Non-Consumable: DupZero Pro Lifetime — $49.99

---

## HATUA 7 — Submit

App Store Connect → Submit for Review
Apple: siku 1-3

---

## Ushauri wa Busara kwa Tavoo

Anza Google Play kwanza ($25 tu).
Ukipata watumiaji na mapato → kisha fanya iOS ($99/mwaka).

# DupZero — Termux Complete Guide
## Tumia Simu Yako Kama PC
## Developed by Tavoo

---

## HATUA 1 — Sakinisha Vifaa

Fungua Termux:
```bash
pkg update -y && pkg upgrade -y
pkg install git -y
pkg install openssh -y
pkg install python -y
```

---

## HATUA 2 — Ruhusa ya Faili

```bash
termux-setup-storage
```
Bonyeza "Allow" — sasa Termux inaweza kufikia faili za simu.

---

## HATUA 3 — Weka Git Config

```bash
git config --global user.name "Tavoo"
git config --global user.email "gmail-yako@gmail.com"
```

---

## HATUA 4 — Extract ZIP

```bash
# Nakili ZIP kutoka Downloads
cp /sdcard/Download/dupzero_PERFECTION_by_Tavoo.zip ~/

# Extract
cd ~
unzip dupzero_PERFECTION_by_Tavoo.zip
cd dupzero
ls
```

---

## HATUA 5 — Tengeneza GitHub Repository

1. Chrome → github.com → Sign up (bure)
2. + → New repository
3. Name: dupzero
4. Private (code yako ni siri)
5. Create repository
6. Copy link: https://github.com/JINA/dupzero.git

---

## HATUA 6 — Tengeneza Personal Access Token

(Badala ya password ya GitHub)

1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token → Classic
4. Note: dupzero-token
5. Expiration: No expiration
6. Scopes: ✓ repo
7. Generate token
8. COPY TOKEN — itaonekana mara moja tu!

---

## HATUA 7 — Push Code GitHub

```bash
cd ~/dupzero
git init
git add .
git commit -m "DupZero v1.1 PERFECTION by Tavoo"
git branch -M main
git remote add origin https://github.com/JINA-LAKO/dupzero.git
git push -u origin main
```

Itakuuliza:
- Username: jina-lako-la-github
- Password: weka TOKEN (sio password ya GitHub)

---

## HATUA 8 — Angalia GitHub Actions

1. Chrome → github.com/JINA-LAKO/dupzero
2. Tab: Actions
3. Utaona "DupZero — Build APK" inaendesha ✅
4. Subiri dakika 10-15
5. Bonyeza workflow → Artifacts
6. Download: DupZero-Debug-APK

---

## HATUA 9 — Install APK

1. Fungua APK uliyodownload
2. "Install from unknown sources" → Allow
3. Install
4. Fungua DupZero! 🎉

---

## HATUA 10 — Weka Firebase (Optional)

```bash
# Baada ya kupata google-services.json kutoka Firebase Console
cp /sdcard/Download/google-services.json ~/dupzero/android/app/

# Push update
cd ~/dupzero
git add .
git commit -m "Add Firebase configuration"
git push
```

GitHub Actions itabuildia APK mpya na Firebase!

---

## Amri za Kila Siku

```bash
# Nenda project
cd ~/dupzero

# Angalia hali
git status

# Ongeza mabadiliko
git add .
git commit -m "Maelezo ya mabadiliko"
git push

# Pull updates (kama ukifanya changes GitHub website)
git pull
```

---

## Weka google-services.json kwenye GitHub Secrets

Ili Firebase ifanye kazi kwenye GitHub Actions:

1. GitHub → repository → Settings → Secrets and variables → Actions
2. New repository secret
3. Name: GOOGLE_SERVICES_JSON
4. Value: nakili content yote ya google-services.json
5. Add secret

Sasa kila build itakuwa na Firebase! ✅

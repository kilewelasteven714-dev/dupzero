# DupZero — Jinsi ya Kutumia Termux + GitHub
## Developed by Tavoo

---

## Hatua ya 1 — Sakinisha Vifaa kwenye Termux

Fungua Termux na andika hivi:

```bash
pkg update -y && pkg upgrade -y
pkg install git -y
pkg install openssh -y
```

---

## Hatua ya 2 — Weka Jina lako kwenye Git

```bash
git config --global user.name "Tavoo"
git config --global user.email "gmail-yako@gmail.com"
```

---

## Hatua ya 3 — Ruhusa ya Kufikia Faili za Simu

```bash
termux-setup-storage
```
Bonyeza "Allow" kwenye popup inayoonekana.

---

## Hatua ya 4 — Nakili ZIP kwenye Termux

```bash
cp /sdcard/Download/dupzero_COMPLETE_by_Tavoo.zip ~/
cd ~
unzip dupzero_COMPLETE_by_Tavoo.zip
cd dupzero
```

---

## Hatua ya 5 — Tengeneza GitHub Repository

1. Fungua Chrome → github.com
2. Bonyeza **"+"** juu kulia → **"New repository"**
3. Repository name: **dupzero**
4. Chagua **Private** (ili code yako iwe salama)
5. Bonyeza **"Create repository"**
6. Copy link inayoonekana kama:
   `https://github.com/jina-lako/dupzero.git`

---

## Hatua ya 6 — Pakia Code GitHub

Rudi Termux:

```bash
cd ~/dupzero
git init
git add .
git commit -m "DupZero v1.1 - Complete app by Tavoo"
git branch -M main
git remote add origin https://github.com/JINA-LAKO/dupzero.git
git push -u origin main
```

Itakuuliza username na password ya GitHub.
**Muhimu:** Badala ya password ya GitHub, tumia **Personal Access Token**:
1. GitHub → Settings → Developer settings → Personal access tokens → Generate new token
2. Chagua scopes: `repo`
3. Copy token na utumie badala ya password

---

## Hatua ya 7 — Angalia GitHub Actions Inafanya Kazi

1. Nenda github.com/JINA-LAKO/dupzero
2. Bonyeza tab ya **"Actions"**
3. Utaona workflow ya **"DupZero — Build APK"** inaendesha
4. Subiri dakika 10-15
5. Bonyeza workflow → **"Artifacts"**
6. Download **DupZero-Debug-APK**
7. Fungua faili kwenye simu yako → install

---

## Hatua ya 8 — Weka google-services.json Salama

Ili Firebase ifanye kazi kwenye GitHub Actions bila kuweka faili kwenye code:

1. GitHub → repository yako → **Settings** → **Secrets and variables** → **Actions**
2. Bonyeza **"New repository secret"**
3. Name: `GOOGLE_SERVICES_JSON`
4. Value: Nakili content yote ya google-services.json yako
5. Bonyeza **"Add secret"**

Sasa kila build itakuwa na Firebase configured!

---

## Hatua ya 9 — Wakati Wowote Ubadilishe Code

```bash
cd ~/dupzero
# Fanya mabadiliko yako...
git add .
git commit -m "Mabadiliko mapya"
git push
```

GitHub Actions itatengeneza APK mpya automatically!

---

## Codemagic (Alternative ya GitHub Actions)

Kama unataka interface rahisi zaidi:

1. Nenda **codemagic.io**
2. Ingia na GitHub account
3. Chagua repository ya dupzero
4. Bonyeza **"Start your first build"**
5. APK itaenda kwenye email yako!

---

## Muhtasari

| Hatua | Unachohitaji |
|-------|-------------|
| Code ipo | ✅ ZIP tayari |
| GitHub | Fungua account bure |
| Termux | Tayari una |
| Build APK | GitHub Actions — automatic |
| Firebase | google-services.json kutoka Firebase Console |
| Keystore (Play Store) | Tengeneza kwa `scripts/create_keystore.sh` |

---

*Maswali yoyote — niulize Tavoo!*

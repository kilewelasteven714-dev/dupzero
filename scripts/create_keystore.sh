#!/bin/bash
# ═══════════════════════════════════════════════════════════
# DupZero — Create Release Keystore
# Run this ONCE on your PC to create your signing keystore
# Developed by Tavoo
# ═══════════════════════════════════════════════════════════

echo "=== DupZero Keystore Generator ==="
echo "Developed by Tavoo"
echo ""

# Create keystore directory
mkdir -p android/keystore

# Generate keystore
keytool -genkey -v \
  -keystore android/keystore/dupzero-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias dupzero \
  -dname "CN=Tavoo, OU=DupZero, O=Tavoo Apps, L=Dar es Salaam, ST=Tanzania, C=TZ"

echo ""
echo "✅ Keystore created at: android/keystore/dupzero-release.jks"
echo ""
echo "Now create android/app/key.properties with your passwords:"
echo "  storePassword=YOUR_PASSWORD"
echo "  keyPassword=YOUR_PASSWORD"
echo "  keyAlias=dupzero"
echo "  storeFile=../keystore/dupzero-release.jks"

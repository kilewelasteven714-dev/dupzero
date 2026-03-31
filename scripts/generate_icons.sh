#!/bin/bash
# ═══════════════════════════════════════════════════════════
# DupZero — Generate App Icons & Splash Screen
# Run after placing your icon at: assets/icons/app_icon.png
# Developed by Tavoo
# ═══════════════════════════════════════════════════════════

echo "=== DupZero Icon Generator ==="

# Install flutter_launcher_icons
flutter pub add flutter_launcher_icons --dev
flutter pub add flutter_native_splash --dev

# Generate icons (requires assets/icons/app_icon.png)
flutter pub run flutter_launcher_icons

# Generate splash screen
flutter pub run flutter_native_splash:create

echo "✅ Icons and splash screen generated!"
echo ""
echo "Your app now has:"
echo "  - Custom app icon on all platforms"
echo "  - Professional splash screen"

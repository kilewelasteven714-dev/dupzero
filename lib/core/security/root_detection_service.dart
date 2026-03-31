import 'dart:io';
import 'package:flutter/foundation.dart';

/// Detects if device is rooted (Android) or jailbroken (iOS)
/// Developed by Tavoo — DupZero Security Layer
class RootDetectionService {
  static bool _checked = false;
  static bool _isRooted = false;

  static Future<bool> isDeviceRooted() async {
    if (_checked) return _isRooted;
    _checked = true;

    // Skip check in debug mode (for development)
    if (kDebugMode) return false;

    if (Platform.isAndroid) {
      _isRooted = await _checkAndroid();
    } else if (Platform.isIOS) {
      _isRooted = await _checkIOS();
    }

    return _isRooted;
  }

  static Future<bool> _checkAndroid() async {
    // Check for common root indicators
    final rootPaths = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
      '/su/bin/su',
    ];

    for (final path in rootPaths) {
      if (await File(path).exists()) return true;
    }

    // Check for Magisk (most common modern root)
    final magiskPaths = [
      '/sbin/.magisk',
      '/cache/.disable_magisk',
      '/dev/.magisk.unblock',
    ];
    for (final path in magiskPaths) {
      if (await File(path).exists()) return true;
    }

    return false;
  }

  static Future<bool> _checkIOS() async {
    final jailbreakPaths = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash',
      '/usr/sbin/sshd',
      '/etc/apt',
      '/private/var/lib/apt/',
    ];

    for (final path in jailbreakPaths) {
      if (await File(path).exists()) return true;
    }

    return false;
  }
}

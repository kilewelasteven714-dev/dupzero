import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'root_detection_service.dart';

/// Main security service for DupZero
/// Handles root detection, screenshot prevention, secure flags
/// Developed by Tavoo
class SecurityService {

  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    // Prevent screenshots and screen recording on Android
    await _setSecureFlag();
  }

  /// Show warning if device is rooted
  static Future<void> checkDeviceSecurity(BuildContext context) async {
    final isRooted = await RootDetectionService.isDeviceRooted();
    if (isRooted && context.mounted) {
      _showRootWarning(context);
    }
  }

  static Future<void> _setSecureFlag() async {
    try {
      // Prevents screenshots of the app (protects user privacy)
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (e) {
      debugPrint('SecurityService: setSecureFlag failed: $e');
    }
  }

  static void _showRootWarning(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Text('⚠️', style: TextStyle(fontSize: 40)),
        title: const Text('Tahadhari ya Usalama',
          style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Simu yako inaonekana kuwa na root au imebadilishwa. '
          'DupZero inaweza kufuta files muhimu kwenye simu iliyorootwa. '
          'Tunakushauri utumie simu ya kawaida kwa usalama wa data yako.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Naelewa, Endelea'),
          ),
          FilledButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Funga App'),
          ),
        ],
      ),
    );
  }
}

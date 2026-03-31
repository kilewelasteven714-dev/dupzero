import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

/// General notification service. Storage-specific alerts are in StorageAlertService.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
    _initialized = true;
  }

  static Future<void> showScanComplete({
    required int duplicates,
    required String wasted,
  }) async {
    await init();
    await _plugin.show(
      1, 'Scan Complete ✓',
      'Found $duplicates duplicates wasting $wasted. Tap to clean up.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.scanChannelId, AppConstants.scanChannelName,
          importance: Importance.high, priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> showDuplicateDetected(String fileName) async {
    await init();
    await _plugin.show(
      2, 'Duplicate Detected ⚡',
      '"$fileName" already exists on your device.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.duplicateAlertChannelId, AppConstants.duplicateAlertChannelName,
          importance: Importance.high,
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
    );
  }

  static Future<void> showScheduledCleanupDone(String freed) async {
    await init();
    await _plugin.show(
      3, 'Auto-Cleanup Complete',
      'DupZero freed $freed during scheduled cleanup.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.scanChannelId, AppConstants.scanChannelName,
          importance: Importance.low,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

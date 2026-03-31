import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import 'storage_alert_service.dart';

const _scanTask = 'dupzero_background_scan';
const _storageCheckTask = 'dupzero_storage_check';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService.init();
    await StorageAlertService.init();

    switch (task) {
      case _scanTask:
        // Run lightweight scan in background (offline — no internet needed)
        // Full implementation: initialize scanner, run scan, delete if auto-cleanup on
        await NotificationService.showScheduledCleanupDone('0 MB');
        return true;

      case _storageCheckTask:
        // Check storage level and fire alert if >= 70% (fully offline)
        await StorageAlertService.checkAndAlert();
        return true;
    }
    return false;
  });
}

class BackgroundScanService {
  static Future<void> initialize() =>
      Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  static Future<void> scheduleDaily() async {
    await Workmanager().registerPeriodicTask(
      'daily_scan', _scanTask, frequency: const Duration(hours: 24));
    await _scheduleStorageCheck();
  }

  static Future<void> scheduleWeekly() async {
    await Workmanager().registerPeriodicTask(
      'weekly_scan', _scanTask, frequency: const Duration(days: 7));
    await _scheduleStorageCheck();
  }

  static Future<void> scheduleMonthly() async {
    await Workmanager().registerPeriodicTask(
      'monthly_scan', _scanTask, frequency: const Duration(days: 30));
    await _scheduleStorageCheck();
  }

  // Storage check runs every 6 hours regardless of scan schedule (fully offline)
  static Future<void> _scheduleStorageCheck() =>
      Workmanager().registerPeriodicTask(
        'storage_check', _storageCheckTask,
        frequency: const Duration(hours: 6));

  static Future<void> cancelAll() => Workmanager().cancelAll();
}

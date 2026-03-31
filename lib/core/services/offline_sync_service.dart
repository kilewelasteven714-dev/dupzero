import 'package:connectivity_plus/connectivity_plus.dart';

/// DupZero is 100% offline for all core features.
/// Online is ONLY used for:
///   1. Detecting duplicates among files being downloaded at that moment
///      (the DownloadWatcherService handles this locally — also offline)
///   2. App updates (handled by the OS store)
///   3. Cloud storage scanning (Google Drive, OneDrive, iCloud) — Pro feature
///   4. Cross-device sync of scan history — Pro feature
///
/// This service exposes connectivity status for the UI and cloud features.
class OfflineSyncService {
  static Stream<bool> get isOnlineStream => Connectivity()
      .onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));

  static Future<bool> get isOnline async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Features available OFFLINE (no internet needed):
  static const offlineFeatures = [
    'SHA-256 exact duplicate detection',
    'AI perceptual hash similar image detection',
    'File deletion (permanent)',
    'Scheduled automatic cleanup',
    'Storage usage monitoring',
    'Storage alert at 70% threshold',
    'Download folder real-time watching',
    'All scan history (stored locally)',
    'All settings and preferences',
    'Dark mode and themes',
    'Analytics and statistics',
  ];

  /// Features that need internet:
  static const onlineOnlyFeatures = [
    'Google Drive / OneDrive / iCloud scanning (Pro)',
    'Cross-device scan history sync (Pro)',
    'App updates (via Play Store / App Store)',
  ];
}

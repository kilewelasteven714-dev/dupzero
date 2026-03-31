class AppConstants {
  // App identity — Developed by Tavoo
  static const String appName = 'DupZero';
  static const String appVersion = '1.1.0';
  static const String developerName = 'Tavoo';
  static const String developerTitle = 'Developed by Tavoo';

  // Hive / SharedPreferences keys
  static const String settingsBox = 'settings_box';
  static const String scanHistoryBox = 'scan_history_box';
  static const String deletedFilesBox = 'deleted_files_box';
  static const String analyticsBox = 'analytics_box';
  static const String themeKey = 'theme_mode';
  static const String colorSeedKey = 'color_seed';
  static const String onboardingKey = 'onboarding_done';
  static const String isPremiumKey = 'is_premium';
  static const String autoDeleteAfterPostKey = 'auto_delete_after_post';
  static const String storageAlertThresholdKey = 'storage_alert_threshold';
  static const String lastStorageAlertKey = 'last_storage_alert';
  static const String downloadWatchEnabledKey = 'download_watch_enabled';
  static const String totalSpaceSavedKey = 'total_space_saved_bytes';

  // Storage alert
  static const double storageAlertThresholdPercent = 70.0; // alert at 70%
  static const int storageAlertCooldownHours = 12; // don't re-alert within 12h

  // File scanning
  static const int hashChunkSize = 65536; // 64 KB
  static const int pHashSize = 8;
  static const int pHashThreshold = 10;

  // Monetization
  static const String premiumMonthlyId = 'dupzero_premium_monthly';
  static const String premiumYearlyId = 'dupzero_premium_yearly';
  static const String premiumLifetimeId = 'dupzero_premium_lifetime';

  // Free tier
  static const int freeMaxFiles = 500;
  static const int freeMaxClouds = 1;

  // Common download paths (watched for real-time detection)
  static const List<String> watchedDownloadPaths = [
    'Download',
    'Downloads',
    'WhatsApp/Media/WhatsApp Images',
    'WhatsApp/Media/WhatsApp Video',
    'Telegram',
    'Pictures',
    'DCIM/Camera',
  ];

  // Notification channel IDs
  static const String storageAlertChannelId = 'storage_alert_channel';
  static const String storageAlertChannelName = 'Storage Alerts';
  static const String duplicateAlertChannelId = 'duplicate_alert_channel';
  static const String duplicateAlertChannelName = 'Duplicate Alerts';
  static const String scanChannelId = 'scan_channel';
  static const String scanChannelName = 'Scan Notifications';
  static const String downloadWatchChannelId = 'download_watch_channel';
  static const String downloadWatchChannelName = 'Download Monitor';
}

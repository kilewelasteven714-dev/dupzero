/// Accessibility semantic labels for DupZero
/// Used by screen readers (TalkBack on Android, VoiceOver on iOS)
/// Developed by Tavoo
class SemanticsLabels {
  // Navigation
  static const home        = 'Home page';
  static const scan        = 'Scan page';
  static const duplicates  = 'Duplicates page';
  static const analytics   = 'Analytics page';
  static const settings    = 'Settings page';

  // Actions
  static const startScan       = 'Start scanning for duplicate files';
  static const cancelScan      = 'Cancel current scan';
  static const deleteSelected  = 'Delete selected duplicate files permanently';
  static const restoreFile     = 'Restore file from recycle bin';
  static const previewFile     = 'Preview file before deletion';
  static const selectFile      = 'Select file for deletion';
  static const keepFile        = 'This file will be kept';

  // Storage
  static const storageBar      = 'Device storage usage indicator';
  static const storageAlert    = 'Storage space warning — device is nearly full';

  // Premium
  static const upgradePro      = 'Upgrade to DupZero Pro subscription';
  static const selectPlan      = 'Select subscription plan';

  // Settings
  static const toggleTheme     = 'Toggle app theme';
  static const toggleScan      = 'Toggle file type for scanning';
  static const colorPicker     = 'Choose app color theme';
}

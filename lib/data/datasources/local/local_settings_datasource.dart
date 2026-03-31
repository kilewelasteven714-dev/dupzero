import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/user_settings.dart';

class LocalSettingsDataSource {
  final SharedPreferences _prefs;
  LocalSettingsDataSource(this._prefs);

  UserSettings getSettings() {
    final modeIdx =
        _prefs.getInt(AppConstants.themeKey) ?? ThemeMode.system.index;
    final colorName =
        _prefs.getString(AppConstants.colorSeedKey) ?? 'Blue Pulse';
    final schedIdx = _prefs.getInt('schedule_frequency') ??
        ScheduleFrequency.none.index;
    return UserSettings(
      themeMode: ThemeMode.values[modeIdx],
      colorThemeName: colorName,
      scheduleFrequency: ScheduleFrequency.values[schedIdx],
      scanImages: _prefs.getBool('scan_images') ?? true,
      scanVideos: _prefs.getBool('scan_videos') ?? true,
      scanAudio: _prefs.getBool('scan_audio') ?? true,
      scanDocuments: _prefs.getBool('scan_documents') ?? true,
      detectSimilarImages: _prefs.getBool('detect_similar') ?? true,
      autoDeleteAfterPost:
          _prefs.getBool(AppConstants.autoDeleteAfterPostKey) ?? false,
      notifyOnNewDuplicate: _prefs.getBool('notify_duplicate') ?? true,
      syncHistory: _prefs.getBool('sync_history') ?? true,
      isPremium: _prefs.getBool(AppConstants.isPremiumKey) ?? false,
    );
  }

  Future<void> saveSettings(UserSettings s) async {
    await _prefs.setInt(AppConstants.themeKey, s.themeMode.index);
    await _prefs.setString(AppConstants.colorSeedKey, s.colorThemeName);
    await _prefs.setInt('schedule_frequency', s.scheduleFrequency.index);
    await _prefs.setBool('scan_images', s.scanImages);
    await _prefs.setBool('scan_videos', s.scanVideos);
    await _prefs.setBool('scan_audio', s.scanAudio);
    await _prefs.setBool('scan_documents', s.scanDocuments);
    await _prefs.setBool('detect_similar', s.detectSimilarImages);
    await _prefs.setBool(
        AppConstants.autoDeleteAfterPostKey, s.autoDeleteAfterPost);
    await _prefs.setBool('notify_duplicate', s.notifyOnNewDuplicate);
    await _prefs.setBool('sync_history', s.syncHistory);
    await _prefs.setBool(AppConstants.isPremiumKey, s.isPremium);
  }
}

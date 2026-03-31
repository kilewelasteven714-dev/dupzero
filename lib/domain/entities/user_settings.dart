import "package:flutter/material.dart";
import "package:equatable/equatable.dart";

enum ScheduleFrequency { none, daily, weekly, monthly }

class UserSettings extends Equatable {
  final ThemeMode themeMode;
  final String colorThemeName;
  final ScheduleFrequency scheduleFrequency;
  final bool scanImages, scanVideos, scanAudio, scanDocuments;
  final bool detectSimilarImages, autoDeleteAfterPost;
  final bool notifyOnNewDuplicate, syncHistory;
  final List<String> excludedPaths;
  final bool isPremium;

  const UserSettings({
    this.themeMode = ThemeMode.system,
    this.colorThemeName = "Blue Pulse",
    this.scheduleFrequency = ScheduleFrequency.none,
    this.scanImages = true, this.scanVideos = true,
    this.scanAudio = true, this.scanDocuments = true,
    this.detectSimilarImages = true, this.autoDeleteAfterPost = false,
    this.notifyOnNewDuplicate = true, this.syncHistory = true,
    this.excludedPaths = const [], this.isPremium = false,
  });

  UserSettings copyWith({
    ThemeMode? themeMode, String? colorThemeName,
    ScheduleFrequency? scheduleFrequency, bool? scanImages, bool? scanVideos,
    bool? scanAudio, bool? scanDocuments, bool? detectSimilarImages,
    bool? autoDeleteAfterPost, bool? notifyOnNewDuplicate, bool? syncHistory,
    List<String>? excludedPaths, bool? isPremium,
  }) => UserSettings(
    themeMode: themeMode ?? this.themeMode, colorThemeName: colorThemeName ?? this.colorThemeName,
    scheduleFrequency: scheduleFrequency ?? this.scheduleFrequency,
    scanImages: scanImages ?? this.scanImages, scanVideos: scanVideos ?? this.scanVideos,
    scanAudio: scanAudio ?? this.scanAudio, scanDocuments: scanDocuments ?? this.scanDocuments,
    detectSimilarImages: detectSimilarImages ?? this.detectSimilarImages,
    autoDeleteAfterPost: autoDeleteAfterPost ?? this.autoDeleteAfterPost,
    notifyOnNewDuplicate: notifyOnNewDuplicate ?? this.notifyOnNewDuplicate,
    syncHistory: syncHistory ?? this.syncHistory,
    excludedPaths: excludedPaths ?? this.excludedPaths, isPremium: isPremium ?? this.isPremium,
  );

  @override
  List<Object?> get props => [themeMode, colorThemeName, scheduleFrequency, scanImages,
    scanVideos, scanAudio, scanDocuments, detectSimilarImages, autoDeleteAfterPost,
    notifyOnNewDuplicate, syncHistory, excludedPaths, isPremium];
}
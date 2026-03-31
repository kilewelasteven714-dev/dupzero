part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final UserSettings settings;
  const UpdateSettingsEvent(this.settings);
  @override List<Object?> get props => [settings];
}

class ScheduleCleanupEvent extends SettingsEvent {
  final ScheduleFrequency frequency;
  const ScheduleCleanupEvent(this.frequency);
  @override List<Object?> get props => [frequency];
}

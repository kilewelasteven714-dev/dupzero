import 'package:dartz/dartz.dart';
import '../entities/user_settings.dart';
import '../../core/errors/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, UserSettings>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(UserSettings settings);
  Future<Either<Failure, Unit>> scheduleCleanup(ScheduleFrequency frequency);
  Future<Either<Failure, Unit>> cancelScheduledCleanup();
}

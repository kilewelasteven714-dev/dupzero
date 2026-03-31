import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/services/background_scan_service.dart';
import '../datasources/local/local_settings_datasource.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LocalSettingsDataSource _local;
  SettingsRepositoryImpl(this._local);

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      return Right(_local.getSettings());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(UserSettings s) async {
    try {
      await _local.saveSettings(s);
      return const Right(unit);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleCleanup(ScheduleFrequency f) async {
    await BackgroundScanService.cancelAll();
    switch (f) {
      case ScheduleFrequency.daily:
        await BackgroundScanService.scheduleDaily();
      case ScheduleFrequency.weekly:
        await BackgroundScanService.scheduleWeekly();
      case ScheduleFrequency.monthly:
        await BackgroundScanService.scheduleMonthly();
      case ScheduleFrequency.none:
        break;
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> cancelScheduledCleanup() async {
    await BackgroundScanService.cancelAll();
    return const Right(unit);
  }
}

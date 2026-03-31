import 'package:dartz/dartz.dart';
import '../repositories/settings_repository.dart';
import '../entities/user_settings.dart';
import '../../core/errors/failures.dart';

class GetSettingsUseCase {
  final SettingsRepository _repo;
  GetSettingsUseCase(this._repo);

  Future<Either<Failure, UserSettings>> call() => _repo.getSettings();
}

class SaveSettingsUseCase {
  final SettingsRepository _repo;
  SaveSettingsUseCase(this._repo);

  Future<Either<Failure, Unit>> call(UserSettings settings) => _repo.saveSettings(settings);
}

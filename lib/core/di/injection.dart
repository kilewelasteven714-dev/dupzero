import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/hash_service.dart';
import '../services/file_scanner_service.dart';
import '../services/background_scan_service.dart';
import '../services/notification_service.dart';
import '../services/storage_alert_service.dart';
import '../security/security_service.dart';
import '../security/root_detection_service.dart';
import '../services/purchase_service.dart';
import '../services/crash_reporting_service.dart';
import '../services/rating_service.dart';
import '../services/download_watcher_service.dart';
import '../services/offline_sync_service.dart';
import '../../data/datasources/local/local_settings_datasource.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../data/repositories/file_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/start_scan_usecase.dart';
import '../../domain/usecases/delete_duplicates_usecase.dart';
import '../../domain/usecases/get_scan_history_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/scan/scan_bloc.dart';
import '../../presentation/blocs/cleanup/cleanup_bloc.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';
import '../../presentation/blocs/storage/storage_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── External ─────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // ── Services ─────────────────────────────────────────────────
  getIt.registerLazySingleton<HashService>(() => HashService());
  getIt.registerLazySingleton<FileScannerService>(() => FileScannerService(getIt()));
  getIt.registerLazySingleton<DownloadWatcherService>(() => DownloadWatcherService(getIt()));

  await NotificationService.init();
  await StorageAlertService.init();
  await BackgroundScanService.initialize();

  // ── Data sources ─────────────────────────────────────────────
  getIt.registerLazySingleton<LocalSettingsDataSource>(
      () => LocalSettingsDataSource(getIt()));

  // ── Repositories ─────────────────────────────────────────────
  getIt.registerLazySingleton<ScanRepository>(() => ScanRepositoryImpl(getIt()));
  getIt.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(getIt()));
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // ── Use Cases ─────────────────────────────────────────────────
  getIt.registerLazySingleton(() => StartScanUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteDuplicatesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetScanHistoryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));

  // ── BLoCs ─────────────────────────────────────────────────────
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc(getIt()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));
  getIt.registerFactory<ScanBloc>(
      () => ScanBloc(startScan: getIt(), getHistory: getIt()));
  getIt.registerFactory<CleanupBloc>(() => CleanupBloc(deleteUseCase: getIt()));
  getIt.registerFactory<SettingsBloc>(() => SettingsBloc(
    getSettings: getIt(), saveSettings: getIt(), repo: getIt()));
  getIt.registerFactory<StorageBloc>(() => StorageBloc());
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/security/security_service.dart';
import 'firebase_options.dart';
import 'presentation/blocs/theme/theme_bloc.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/scan/scan_bloc.dart';
import 'presentation/blocs/cleanup/cleanup_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/storage/storage_bloc.dart';

/// DupZero — Intelligent Duplicate File Cleaner
/// Developed by Tavoo
/// Version: 1.1.0
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Security first ───────────────────────────────────────
  await SecurityService.initialize();

  // ── Hive local database ──────────────────────────────────
  await Hive.initFlutter();

  // ── Firebase (graceful offline fallback) ─────────────────
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // No google-services.json yet — app runs offline
    debugPrint('Firebase offline mode: $e');
  }

  // ── Dependency injection ─────────────────────────────────
  await configureDependencies();

  // ── Status bar transparent ───────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const DupZeroApp());
}

class DupZeroApp extends StatelessWidget {
  const DupZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()..add(LoadThemeEvent())),
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => getIt<ScanBloc>()),
        BlocProvider(create: (_) => getIt<CleanupBloc>()),
        BlocProvider(create: (_) => getIt<SettingsBloc>()..add(LoadSettingsEvent())),
        BlocProvider(create: (_) => getIt<StorageBloc>()..add(LoadStorageEvent())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'DupZero',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(themeState.colorSeed),
            darkTheme: AppTheme.darkTheme(themeState.colorSeed),
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              // Check device security after first frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SecurityService.checkDeviceSecurity(context);
              });
              return child!;
            },
          );
        },
      ),
    );
  }
}

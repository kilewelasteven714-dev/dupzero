import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/scan_page.dart';
import '../../presentation/pages/duplicates_page.dart';
import '../../presentation/pages/analytics_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/auth_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/premium_page.dart';
import '../../presentation/pages/trash_page.dart';
import '../../presentation/pages/excluded_folders_page.dart';
import '../../presentation/pages/qr_payment_page.dart';
import '../../presentation/pages/qr_scanner_page.dart';
import '../../presentation/widgets/main_scaffold.dart';

class AppRouter {
  static final _key = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _key,
    initialLocation: '/',
    redirect: _redirect,
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthPage()),

      ShellRoute(
        builder: (_, __, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomePage()),
          GoRoute(path: '/scan', builder: (_, __) => const ScanPage()),
          GoRoute(path: '/duplicates', builder: (_, __) => const DuplicatesPage()),
          GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsPage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        ],
      ),

      // Feature pages (no bottom nav)
      GoRoute(path: '/premium', builder: (_, __) => const PremiumPage()),
      GoRoute(path: '/qr-payment', builder: (_, __) => const QRPaymentPage()),
      GoRoute(path: '/qr-scanner', builder: (_, __) => const QRScannerPage()),
      GoRoute(path: '/trash', builder: (_, __) => const TrashPage()),
      GoRoute(path: '/excluded-folders', builder: (_, __) => const ExcludedFoldersPage()),
    ],
  );

  static Future<String?> _redirect(BuildContext ctx, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool(AppConstants.onboardingKey) ?? false;
    if (!onboarded && state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }
    return null;
  }
}

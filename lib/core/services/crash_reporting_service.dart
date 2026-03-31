import 'package:flutter/foundation.dart';

/// Crash reporting for DupZero
/// In production: replace with sentry_flutter
/// Developed by Tavoo
class CrashReportingService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    // TODO: Add your Sentry DSN from sentry.io (free tier available)
    // await SentryFlutter.init((options) {
    //   options.dsn = 'YOUR_SENTRY_DSN';
    //   options.tracesSampleRate = 0.2;
    //   options.environment = kDebugMode ? 'development' : 'production';
    // });
    debugPrint('CrashReporting: initialized (stub — add Sentry DSN)');
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      // In debug: just print
      debugPrint('ERROR[$context]: $exception');
      if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
      return;
    }
    // In release: send to Sentry
    // await Sentry.captureException(exception, stackTrace: stackTrace);
  }

  static Future<void> recordMessage(String message, {String? context}) async {
    debugPrint('[$context] $message');
    // await Sentry.captureMessage(message);
  }

  static void setUser(String userId, String email) {
    // Sentry.configureScope((scope) => scope.setUser(SentryUser(id: userId, email: email)));
  }

  static void clearUser() {
    // Sentry.configureScope((scope) => scope.setUser(null));
  }
}

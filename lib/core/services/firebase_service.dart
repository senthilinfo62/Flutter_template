// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../utils/logger.dart';

/// Firebase service provider
final firebaseServiceProvider = Provider<FirebaseService>(
  (ref) => FirebaseService(),
);

/// Firebase service for analytics, crashlytics, and performance monitoring
class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebasePerformance? _performance;

  /// Initialize Firebase services (assumes Firebase.initializeApp() already called)
  static Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _performance = FirebasePerformance.instance;

      // Enable crashlytics collection in release mode
      if (kReleaseMode) {
        await _crashlytics?.setCrashlyticsCollectionEnabled(true);
      }

      // Set up automatic crash reporting
      FlutterError.onError = _crashlytics?.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics?.recordError(error, stack, fatal: true);
        return true;
      };

      AppLogger.info('Firebase services initialized successfully');
    } on Exception catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Firebase services', e, stackTrace);
    }
  }

  /// Get Firebase Analytics instance
  static FirebaseAnalytics? get analytics => _analytics;

  /// Get Firebase Crashlytics instance
  static FirebaseCrashlytics? get crashlytics => _crashlytics;

  /// Get Firebase Performance instance
  static FirebasePerformance? get performance => _performance;

  /// Log custom event
  static Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(
        name: name,
        parameters: parameters?.cast<String, Object>(),
      );
      AppLogger.debug('Analytics event logged: $name');
    } on Exception catch (e) {
      AppLogger.error('Failed to log analytics event: $name', e);
    }
  }

  /// Set user properties
  static Future<void> setUserProperties({
    String? userId,
    Map<String, String>? properties,
  }) async {
    try {
      if (userId != null) {
        await _analytics?.setUserId(id: userId);
      }

      if (properties != null) {
        for (final entry in properties.entries) {
          await _analytics?.setUserProperty(
            name: entry.key,
            value: entry.value,
          );
        }
      }

      AppLogger.debug('User properties set');
    } on Exception catch (e) {
      AppLogger.error('Failed to set user properties', e);
    }
  }

  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      AppLogger.debug('Screen view logged: $screenName');
    } on Exception catch (e) {
      AppLogger.error('Failed to log screen view: $screenName', e);
    }
  }

  /// Record custom error
  static Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics?.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
      AppLogger.debug('Error recorded to Crashlytics');
    } on Exception catch (e) {
      AppLogger.error('Failed to record error to Crashlytics', e);
    }
  }

  /// Start performance trace
  static Trace? startTrace(String traceName) {
    try {
      final trace = _performance?.newTrace(traceName);
      trace?.start();
      AppLogger.debug('Performance trace started: $traceName');
      return trace;
    } on Exception catch (e) {
      AppLogger.error('Failed to start performance trace: $traceName', e);
      return null;
    }
  }

  /// Stop performance trace
  static Future<void> stopTrace(Trace? trace) async {
    try {
      await trace?.stop();
      AppLogger.debug('Performance trace stopped');
    } on Exception catch (e) {
      AppLogger.error('Failed to stop performance trace', e);
    }
  }

  /// Add custom metric to trace
  static void addTraceMetric(Trace? trace, String metricName, int value) {
    try {
      trace?.setMetric(metricName, value);
      AppLogger.debug('Trace metric added: $metricName = $value');
    } on Exception catch (e) {
      AppLogger.error('Failed to add trace metric: $metricName', e);
    }
  }

  /// Set custom key for crashlytics
  static Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics?.setCustomKey(key, value);
      AppLogger.debug('Custom key set: $key = $value');
    } on Exception catch (e) {
      AppLogger.error('Failed to set custom key: $key', e);
    }
  }

  /// Log custom message
  static Future<void> log(String message) async {
    try {
      await _crashlytics?.log(message);
      AppLogger.debug('Message logged to Crashlytics: $message');
    } on Exception catch (e) {
      AppLogger.error('Failed to log message to Crashlytics', e);
    }
  }
}

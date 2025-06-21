import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_service.dart';

/// Analytics service provider
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);

/// Analytics service for tracking user events and behavior
class AnalyticsService {
  /// Track user login
  static Future<void> trackLogin(String method) async {
    await FirebaseService.logEvent(
      name: 'login',
      parameters: {
        'method': method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track user signup
  static Future<void> trackSignup(String method) async {
    await FirebaseService.logEvent(
      name: 'sign_up',
      parameters: {
        'method': method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track todo creation
  static Future<void> trackTodoCreated() async {
    await FirebaseService.logEvent(
      name: 'todo_created',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  /// Track todo completion
  static Future<void> trackTodoCompleted() async {
    await FirebaseService.logEvent(
      name: 'todo_completed',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  /// Track todo deletion
  static Future<void> trackTodoDeleted() async {
    await FirebaseService.logEvent(
      name: 'todo_deleted',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  /// Track search usage
  static Future<void> trackSearch(String query) async {
    await FirebaseService.logEvent(
      name: 'search',
      parameters: {
        'search_term': query.isNotEmpty ? 'has_query' : 'empty_query',
        'query_length': query.length,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track theme change
  static Future<void> trackThemeChanged(String theme) async {
    await FirebaseService.logEvent(
      name: 'theme_changed',
      parameters: {
        'theme': theme,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track language change
  static Future<void> trackLanguageChanged(String language) async {
    await FirebaseService.logEvent(
      name: 'language_changed',
      parameters: {
        'language': language,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track screen view
  static Future<void> trackScreenView(String screenName) async {
    await FirebaseService.logScreenView(
      screenName: screenName,
      screenClass: 'Flutter',
    );
  }

  /// Track error
  static Future<void> trackError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
  }) async {
    await FirebaseService.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage.length > 100
            ? '${errorMessage.substring(0, 100)}...'
            : errorMessage,
        'has_stack_trace': stackTrace != null,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track performance metric
  static Future<void> trackPerformance({
    required String metricName,
    required int value,
    String? unit,
  }) async {
    await FirebaseService.logEvent(
      name: 'performance_metric',
      parameters: {
        'metric_name': metricName,
        'value': value,
        'unit': unit ?? 'ms',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track user engagement
  static Future<void> trackEngagement({
    required String action,
    String? category,
    String? label,
    int? value,
  }) async {
    await FirebaseService.logEvent(
      name: 'user_engagement',
      parameters: {
        'action': action,
        'category': category ?? 'general',
        'label': label,
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Set user properties
  static Future<void> setUserProperties({
    String? userId,
    String? userType,
    String? preferredLanguage,
    String? preferredTheme,
  }) async {
    final properties = <String, String>{};

    if (userType != null) {
      properties['user_type'] = userType;
    }
    if (preferredLanguage != null) {
      properties['preferred_language'] = preferredLanguage;
    }
    if (preferredTheme != null) {
      properties['preferred_theme'] = preferredTheme;
    }

    await FirebaseService.setUserProperties(
      userId: userId,
      properties: properties,
    );
  }

  /// Track app launch
  static Future<void> trackAppLaunch() async {
    await FirebaseService.logEvent(
      name: 'app_launch',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  /// Track app background
  static Future<void> trackAppBackground() async {
    await FirebaseService.logEvent(
      name: 'app_background',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  /// Track feature usage
  static Future<void> trackFeatureUsage(String featureName) async {
    await FirebaseService.logEvent(
      name: 'feature_used',
      parameters: {
        'feature_name': featureName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}

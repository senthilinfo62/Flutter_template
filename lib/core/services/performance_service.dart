import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';
import 'analytics_service.dart';
import 'firebase_service.dart';

/// Performance service provider
final performanceServiceProvider = Provider<PerformanceService>(
  (ref) => PerformanceService(),
);

/// Performance monitoring service
class PerformanceService {
  static final Map<String, Trace> _activeTraces = {};
  static final Map<String, DateTime> _operationStartTimes = {};

  /// Start monitoring an operation
  static Future<void> startOperation(String operationName) async {
    try {
      _operationStartTimes[operationName] = DateTime.now();

      final trace = FirebaseService.startTrace(operationName);
      if (trace != null) {
        _activeTraces[operationName] = trace;
      }

      AppLogger.debug('Started monitoring operation: $operationName');
    } on Exception catch (e) {
      AppLogger.error(
        'Failed to start operation monitoring: $operationName',
        e,
      );
    }
  }

  /// Stop monitoring an operation
  static Future<void> stopOperation(String operationName) async {
    try {
      final startTime = _operationStartTimes[operationName];
      final trace = _activeTraces[operationName];

      if (startTime != null) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;

        // Add duration metric to trace
        if (trace != null) {
          FirebaseService.addTraceMetric(trace, 'duration_ms', duration);
        }

        // Log performance metric to analytics
        await AnalyticsService.trackPerformance(
          metricName: operationName,
          value: duration,
          unit: 'ms',
        );

        _operationStartTimes.remove(operationName);
      }

      if (trace != null) {
        await FirebaseService.stopTrace(trace);
        _activeTraces.remove(operationName);
      }

      AppLogger.debug('Stopped monitoring operation: $operationName');
    } on Exception catch (e) {
      AppLogger.error('Failed to stop operation monitoring: $operationName', e);
    }
  }

  /// Monitor a future operation
  static Future<T> monitorOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    await startOperation(operationName);
    try {
      final result = await operation();
      await stopOperation(operationName);
      return result;
    } catch (e) {
      await stopOperation(operationName);
      rethrow;
    }
  }

  /// Monitor network request
  static Future<T> monitorNetworkRequest<T>(
    String endpoint,
    Future<T> Function() request,
  ) async {
    final operationName = 'network_request_${endpoint.replaceAll('/', '_')}';
    return monitorOperation(operationName, request);
  }

  /// Monitor database operation
  static Future<T> monitorDatabaseOperation<T>(
    String operation,
    Future<T> Function() dbOperation,
  ) async {
    final operationName = 'db_operation_$operation';
    return monitorOperation(operationName, dbOperation);
  }

  /// Monitor UI operation
  static Future<T> monitorUIOperation<T>(
    String operation,
    Future<T> Function() uiOperation,
  ) async {
    final operationName = 'ui_operation_$operation';
    return monitorOperation(operationName, uiOperation);
  }

  /// Add custom metric to active trace
  static void addMetric(String operationName, String metricName, int value) {
    try {
      final trace = _activeTraces[operationName];
      if (trace != null) {
        FirebaseService.addTraceMetric(trace, metricName, value);
        AppLogger.debug('Added metric to $operationName: $metricName = $value');
      }
    } on Exception catch (e) {
      AppLogger.error('Failed to add metric to $operationName', e);
    }
  }

  /// Monitor app startup
  static Future<void> monitorAppStartup() async {
    await startOperation('app_startup');
  }

  /// Complete app startup monitoring
  static Future<void> completeAppStartup() async {
    await stopOperation('app_startup');
  }

  /// Monitor screen load time
  static Future<void> startScreenLoad(String screenName) async {
    await startOperation('screen_load_$screenName');
  }

  /// Complete screen load monitoring
  static Future<void> completeScreenLoad(String screenName) async {
    await stopOperation('screen_load_$screenName');
  }

  /// Monitor image loading
  static Future<void> startImageLoad(String imageUrl) async {
    final imageName = imageUrl.split('/').last.split('?').first;
    await startOperation('image_load_$imageName');
  }

  /// Complete image load monitoring
  static Future<void> completeImageLoad(String imageUrl) async {
    final imageName = imageUrl.split('/').last.split('?').first;
    await stopOperation('image_load_$imageName');
  }

  /// Monitor cache operations
  static Future<T> monitorCacheOperation<T>(
    String cacheType,
    String operation,
    Future<T> Function() cacheOperation,
  ) async {
    final operationName = 'cache_${cacheType}_$operation';
    return monitorOperation(operationName, cacheOperation);
  }

  /// Get performance summary
  static Map<String, dynamic> getPerformanceSummary() => {
    'active_traces': _activeTraces.keys.toList(),
    'active_operations': _operationStartTimes.keys.toList(),
    'total_active_operations': _activeTraces.length,
  };

  /// Clear all active traces (for cleanup)
  static Future<void> clearAllTraces() async {
    try {
      for (final trace in _activeTraces.values) {
        await FirebaseService.stopTrace(trace);
      }
      _activeTraces.clear();
      _operationStartTimes.clear();
      AppLogger.debug('Cleared all active performance traces');
    } on Exception catch (e) {
      AppLogger.error('Failed to clear performance traces', e);
    }
  }

  /// Monitor memory usage
  static Future<void> trackMemoryUsage() async {
    try {
      // This would require platform-specific implementation
      // For now, we'll track it as a custom event
      await AnalyticsService.trackPerformance(
        metricName: 'memory_check',
        value: DateTime.now().millisecondsSinceEpoch,
        unit: 'timestamp',
      );
    } on Exception catch (e) {
      AppLogger.error('Failed to track memory usage', e);
    }
  }
}

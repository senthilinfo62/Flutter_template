// Dart imports:
import 'dart:io';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import '../errors/exceptions.dart';

/// Provider for Push Notification Service
final pushNotificationServiceProvider = Provider<PushNotificationService>(
  (ref) => PushNotificationService(),
);

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger()
    ..i('Handling background message: ${message.messageId}')
    ..i('Background message data: ${message.data}');
}

/// Push Notification Service for handling Firebase Cloud Messaging
class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final Logger _logger = Logger();

  /// Initialize push notifications
  Future<void> initialize() async {
    try {
      // Request permission for iOS
      await _requestPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      _handleForegroundMessages();

      // Handle notification taps
      _handleNotificationTaps();

      // Get and log FCM token
      final token = await getToken();
      _logger.i('FCM Token: $token');
    } catch (e) {
      _logger.e('Failed to initialize push notifications: $e');
      throw PushNotificationException(
        message: 'Failed to initialize push notifications: $e',
      );
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission();

    _logger.i(
      'Notification permission status: ${settings.authorizationStatus}',
    );
    return settings;
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  /// Handle foreground messages
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      _logger
        ..i('Received foreground message: ${message.messageId}')
        ..i('Message data: ${message.data}');

      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
  }

  /// Handle notification taps when app is in background/terminated
  void _handleNotificationTaps() {
    // Handle notification tap when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _logger.i(
          'App opened from terminated state via notification: ${message.messageId}',
        );
        _handleNotificationNavigation(message);
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logger.i(
        'App opened from background via notification: ${message.messageId}',
      );
      _handleNotificationNavigation(message);
    });
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    _logger.i('Notification tapped with payload: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    _logger.i('Handling notification navigation with data: $data');

    // Add your navigation logic here based on message data
    // Example: Navigate to specific screen based on 'type' or 'route' in data
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      // Check if running on iOS simulator
      if (Platform.isIOS) {
        // Try to get APNS token first for iOS
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          _logger.w(
            'APNS token not available - this is normal on iOS simulator',
          );
          // On simulator, we can still try to get FCM token but it might fail
          if (kDebugMode) {
            _logger.i(
              'Running in debug mode on iOS - FCM token may not be available on simulator',
            );
          }
        }
      }

      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        _logger.i('FCM Token retrieved successfully');
        // Don't log the full token for security reasons in production
        if (kDebugMode) {
          _logger.i('FCM Token: ${token.substring(0, 20)}...');
        }
      } else {
        _logger.w('FCM Token is null - this is normal on iOS simulator');
      }
      return token;
    } on Exception catch (e) {
      if (e.toString().contains('apns-token-not-set')) {
        _logger.w(
          'APNS token not set - this is expected on iOS simulator. FCM will work on real devices.',
        );
        return null;
      } else {
        _logger.e('Failed to get FCM token: $e');
        return null;
      }
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      if (e.toString().contains('apns-token-not-set')) {
        _logger.w(
          'Cannot subscribe to topic on iOS simulator - this will work on real devices',
        );
        return; // Don't throw exception for simulator
      } else {
        _logger.e('Failed to subscribe to topic $topic: $e');
        throw PushNotificationException(
          message: 'Failed to subscribe to topic: $e',
        );
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Failed to unsubscribe from topic $topic: $e');
      throw PushNotificationException(
        message: 'Failed to unsubscribe from topic: $e',
      );
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _logger.i('FCM token deleted');
    } catch (e) {
      _logger.e('Failed to delete FCM token: $e');
      throw PushNotificationException(
        message: 'Failed to delete FCM token: $e',
      );
    }
  }
}

/// Custom exception for push notification errors
class PushNotificationException extends AppException {
  PushNotificationException({required super.message, super.statusCode});
}

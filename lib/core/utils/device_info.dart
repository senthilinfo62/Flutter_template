import 'dart:io';

import 'package:flutter/foundation.dart';

/// Device information utility
class DeviceInfo {
  /// Check if running on mobile platform
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Check if running on desktop platform
  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if running on Android
  static bool get isAndroid => Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS => Platform.isIOS;

  /// Check if running on Windows
  static bool get isWindows => Platform.isWindows;

  /// Check if running on macOS
  static bool get isMacOS => Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux => Platform.isLinux;

  /// Check if running in debug mode
  static bool get isDebug => kDebugMode;

  /// Check if running in release mode
  static bool get isRelease => kReleaseMode;

  /// Check if running in profile mode
  static bool get isProfile => kProfileMode;

  /// Get platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Get build mode
  static String get buildMode {
    if (kDebugMode) return 'Debug';
    if (kReleaseMode) return 'Release';
    if (kProfileMode) return 'Profile';
    return 'Unknown';
  }
}

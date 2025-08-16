import 'dart:io';

import 'package:flutter/foundation.dart';

/// Utility class for device-related checks
class DeviceUtils {
  /// Check if running on iOS simulator
  static bool get isIOSSimulator {
    if (!Platform.isIOS) return false;
    
    // In debug mode, we can assume simulator for development
    // In production, this would need more sophisticated detection
    return kDebugMode;
  }
  
  /// Check if running on Android emulator
  static bool get isAndroidEmulator {
    if (!Platform.isAndroid) return false;
    
    // In debug mode, we can assume emulator for development
    // In production, this would need more sophisticated detection
    return kDebugMode;
  }
  
  /// Check if running on any simulator/emulator
  static bool get isSimulator => isIOSSimulator || isAndroidEmulator;
  
  /// Check if running on a real device
  static bool get isRealDevice => !isSimulator;
  
  /// Get platform name
  static String get platformName {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  /// Get device type description
  static String get deviceTypeDescription {
    if (isIOSSimulator) return 'iOS Simulator';
    if (isAndroidEmulator) return 'Android Emulator';
    if (Platform.isIOS) return 'iOS Device';
    if (Platform.isAndroid) return 'Android Device';
    return '$platformName Device';
  }
  
  /// Check if push notifications are supported
  static bool get supportsPushNotifications {
    // Push notifications work on real devices
    if (isRealDevice) return true;
    
    // Android emulator supports push notifications
    if (isAndroidEmulator) return true;
    
    // iOS simulator has limited push notification support
    if (isIOSSimulator) return false;
    
    return false;
  }
}

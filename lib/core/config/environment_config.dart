import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart' as prod;
import '../../firebase_options_dev.dart' as dev;
import '../../firebase_options_stg.dart' as stg;

/// Environment types
enum Environment {
  dev,
  stg,
  prod,
}

/// Environment configuration class
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.prod;

  /// Get current environment
  static Environment get currentEnvironment => _currentEnvironment;

  /// Set current environment
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }

  /// Get environment from string
  static Environment getEnvironmentFromString(String? env) {
    switch (env?.toLowerCase()) {
      case 'dev':
      case 'development':
        return Environment.dev;
      case 'stg':
      case 'staging':
        return Environment.stg;
      case 'prod':
      case 'production':
      default:
        return Environment.prod;
    }
  }

  /// Get Firebase options for current environment
  static FirebaseOptions get firebaseOptions {
    switch (_currentEnvironment) {
      case Environment.dev:
        return dev.DefaultFirebaseOptions.currentPlatform;
      case Environment.stg:
        return stg.DefaultFirebaseOptions.currentPlatform;
      case Environment.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }

  /// Get app name for current environment
  static String get appName {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'Flutter Projects Dev';
      case Environment.stg:
        return 'Flutter Projects Staging';
      case Environment.prod:
        return 'Flutter Projects';
    }
  }

  /// Get app suffix for current environment
  static String get appSuffix {
    switch (_currentEnvironment) {
      case Environment.dev:
        return '.dev';
      case Environment.stg:
        return '.stg';
      case Environment.prod:
        return '';
    }
  }

  /// Get base API URL for current environment
  static String get baseApiUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'https://api-dev.example.com';
      case Environment.stg:
        return 'https://api-stg.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }

  /// Check if current environment is development
  static bool get isDev => _currentEnvironment == Environment.dev;

  /// Check if current environment is staging
  static bool get isStg => _currentEnvironment == Environment.stg;

  /// Check if current environment is production
  static bool get isProd => _currentEnvironment == Environment.prod;

  /// Check if current environment is debug (dev or stg)
  static bool get isDebug => isDev || isStg;

  /// Get environment display name
  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'Development';
      case Environment.stg:
        return 'Staging';
      case Environment.prod:
        return 'Production';
    }
  }

  /// Get environment short name
  static String get environmentShortName {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'DEV';
      case Environment.stg:
        return 'STG';
      case Environment.prod:
        return 'PROD';
    }
  }
}

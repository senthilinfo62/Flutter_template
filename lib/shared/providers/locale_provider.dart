// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../../core/constants/app_constants.dart';
import '../../core/providers/shared_preferences_provider.dart';

/// Locale notifier for managing app language
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._sharedPreferences) : super(const Locale('en')) {
    _loadLocale();
  }

  final SharedPreferences _sharedPreferences;

  /// Load locale from storage
  void _loadLocale() {
    final languageCode =
        _sharedPreferences.getString(AppConstants.languageKey) ?? 'en';
    state = Locale(languageCode);
  }

  /// Set locale and save to storage
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _sharedPreferences.setString(
      AppConstants.languageKey,
      locale.languageCode,
    );
  }

  /// Get supported locales
  static const List<Locale> supportedLocales = [Locale('en'), Locale('es')];

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }
}

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(sharedPreferences);
});

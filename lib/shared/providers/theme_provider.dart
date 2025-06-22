// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import '../../core/constants/app_constants.dart';
import '../../core/providers/shared_preferences_provider.dart';

/// Theme mode notifier for managing app theme
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._sharedPreferences) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final SharedPreferences _sharedPreferences;

  /// Load theme mode from storage
  void _loadThemeMode() {
    final themeIndex = _sharedPreferences.getInt(AppConstants.themeKey) ?? 0;
    state = ThemeMode.values[themeIndex];
  }

  /// Set theme mode and save to storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _sharedPreferences.setInt(AppConstants.themeKey, themeMode.index);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.light);
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
    }
  }
}

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(sharedPreferences);
});

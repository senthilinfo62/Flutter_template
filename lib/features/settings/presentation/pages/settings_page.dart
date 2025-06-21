import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../shared/providers/locale_provider.dart';
import '../../../../shared/providers/theme_provider.dart';

/// Settings page for app configuration
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Theme Section
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(AppConstants.defaultPadding),
                ListTile(
                  leading: Icon(
                    _getThemeIcon(themeMode),
                    color: colorScheme.primary,
                  ),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeDisplayName(themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context, ref),
                ),
              ],
            ),
          ),

          const Gap(AppConstants.defaultPadding),

          // Language Section
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(AppConstants.defaultPadding),
                ListTile(
                  leading: Icon(Icons.language, color: colorScheme.primary),
                  title: const Text('Language'),
                  subtitle: Text(
                    ref
                        .read(localeProvider.notifier)
                        .getLocaleDisplayName(locale),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context, ref),
                ),
              ],
            ),
          ),

          const Gap(AppConstants.defaultPadding),

          // About Section
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(AppConstants.defaultPadding),
                ListTile(
                  leading: Icon(Icons.info_outline, color: colorScheme.primary),
                  title: const Text('Version'),
                  subtitle: const Text(AppConstants.appVersion),
                ),
                ListTile(
                  leading: Icon(Icons.code, color: colorScheme.primary),
                  title: const Text('App Name'),
                  subtitle: const Text(AppConstants.appName),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }

  String _getThemeDisplayName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values
              .map(
                (mode) => RadioListTile<ThemeMode>(
                  title: Text(_getThemeDisplayName(mode)),
                  value: mode,
                  groupValue: ref.read(themeModeProvider),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleNotifier.supportedLocales.map((locale) {
            final notifier = ref.read(localeProvider.notifier);
            return RadioListTile<Locale>(
              title: Text(notifier.getLocaleDisplayName(locale)),
              value: locale,
              groupValue: ref.read(localeProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

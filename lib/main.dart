// Flutter imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'core/config/environment_config.dart';
import 'core/navigation/app_router.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/services/firebase_service.dart';
import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment to production
  EnvironmentConfig.setEnvironment(Environment.prod);

  // Initialize Firebase with production options
  try {
    await Firebase.initializeApp(options: EnvironmentConfig.firebaseOptions);
  } on Exception {
    // Firebase already initialized, continue
  }

  // Initialize Firebase services (Analytics, Crashlytics, Performance)
  await FirebaseService.initialize();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Push Notifications
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Override shared preferences provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: EnvironmentConfig.appName,
        debugShowCheckedModeBanner: EnvironmentConfig.isDebug,

        // Router configuration
        routerConfig: AppRouter.router,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,

        // Localization configuration
        locale: locale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
      ),
    );
  }
}

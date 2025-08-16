// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app_colors.dart';

/// Application text styles
class AppTextStyles {
  static const String _fontFamily = 'Inter';

  // Light Theme Text Styles
  static TextTheme get lightTextTheme => const TextTheme(
    // Display Styles
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),

    // Headline Styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),

    // Title Styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.lightOnBackground,
      fontFamily: _fontFamily,
    ),

    // Body Styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),

    // Label Styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.lightOnSurface,
      fontFamily: _fontFamily,
    ),
  );

  // Dark Theme Text Styles
  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
    displayLarge: lightTextTheme.displayLarge?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    displayMedium: lightTextTheme.displayMedium?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    displaySmall: lightTextTheme.displaySmall?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    headlineLarge: lightTextTheme.headlineLarge?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    headlineMedium: lightTextTheme.headlineMedium?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    headlineSmall: lightTextTheme.headlineSmall?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    titleLarge: lightTextTheme.titleLarge?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    titleMedium: lightTextTheme.titleMedium?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    titleSmall: lightTextTheme.titleSmall?.copyWith(
      color: AppColors.darkOnBackground,
    ),
    bodyLarge: lightTextTheme.bodyLarge?.copyWith(
      color: AppColors.darkOnSurface,
    ),
    bodyMedium: lightTextTheme.bodyMedium?.copyWith(
      color: AppColors.darkOnSurface,
    ),
    bodySmall: lightTextTheme.bodySmall?.copyWith(
      color: AppColors.darkOnSurface,
    ),
    labelLarge: lightTextTheme.labelLarge?.copyWith(
      color: AppColors.darkOnSurface,
    ),
    labelMedium: lightTextTheme.labelMedium?.copyWith(
      color: AppColors.darkOnSurface,
    ),
    labelSmall: lightTextTheme.labelSmall?.copyWith(
      color: AppColors.darkOnSurface,
    ),
  );

  // Custom Text Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontFamily: _fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.grey500,
    fontFamily: _fontFamily,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.grey500,
    fontFamily: _fontFamily,
  );
}

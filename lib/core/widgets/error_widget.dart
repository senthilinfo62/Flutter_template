// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:gap/gap.dart';

// Project imports:
import '../constants/app_constants.dart';
import 'app_button.dart';

// Constants for error widget styling
const double _kIconSize = 64;
const TextAlign _kTextAlign = TextAlign.center;

/// A reusable error widget that displays error messages with optional retry functionality.
///
/// This widget provides a consistent error UI across the application with:
/// - Customizable error icon
/// - Error title and message
/// - Optional retry button
/// - Responsive design with proper spacing
///
/// Example usage:
/// ```dart
/// AppErrorWidget(
///   title: 'Network Error',
///   message: 'Please check your internet connection',
///   onRetry: () => _retryOperation(),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.icon,
    this.title,
    this.showRetryButton = true,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? title;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: _kIconSize,
              color: colorScheme.error,
            ),
            const Gap(AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: _kTextAlign,
              ),
              const Gap(AppConstants.smallPadding),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: _kTextAlign,
            ),
            if (showRetryButton && onRetry != null) ...[
              const Gap(AppConstants.largePadding),
              AppButton(text: 'Retry', onPressed: onRetry, icon: Icons.refresh),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppErrorWidget(
    title: 'No Internet Connection',
    message: 'Please check your internet connection and try again.',
    icon: Icons.wifi_off,
    onRetry: onRetry,
  );
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  const ServerErrorWidget({super.key, this.onRetry, this.message});

  final VoidCallback? onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) => AppErrorWidget(
    title: 'Server Error',
    message:
        message ?? 'Something went wrong on our end. Please try again later.',
    icon: Icons.cloud_off,
    onRetry: onRetry,
  );
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message,
    super.key,
    this.icon,
    this.title,
    this.actionText,
    this.onAction,
  });

  final String message;
  final IconData? icon;
  final String? title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: _kIconSize,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const Gap(AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: _kTextAlign,
              ),
              const Gap(AppConstants.smallPadding),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: _kTextAlign,
            ),
            if (actionText != null && onAction != null) ...[
              const Gap(AppConstants.largePadding),
              AppButton(text: actionText!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

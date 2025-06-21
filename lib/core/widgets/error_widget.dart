import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import '../constants/app_constants.dart';
import 'app_button.dart';

/// Generic error widget that can be used throughout the app
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.message,
    super.key,
    this.title,
    this.icon,
    this.showRetryButton = true,
    this.onRetry,
  });

  final String message;
  final String? title;
  final IconData? icon;
  final bool showRetryButton;
  final VoidCallback? onRetry;

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
              size: 64,
              color: colorScheme.error,
            ),
            Gap(AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(AppConstants.smallPadding),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (showRetryButton && onRetry != null) ...[
              Gap(AppConstants.largePadding),
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
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            Gap(AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(AppConstants.smallPadding),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              Gap(AppConstants.largePadding),
              AppButton(text: actionText!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/optimized_image.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

/// Profile page for user account management
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, ref),
          ),
        ],
      ),
      body: _buildBody(context, ref, authState, theme, colorScheme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (authState is AuthLoading || authState is AuthInitial) {
      return const LoadingWidget(message: 'Loading profile...');
    }

    if (authState is Authenticated) {
      final user = authState.user;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // Profile header
            AppCard(
              child: Column(
                children: [
                  // Avatar
                  OptimizedAvatar(
                    imageUrl: user.avatar,
                    radius: 50,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: colorScheme.primary,
                  ),
                  const Gap(AppConstants.defaultPadding),

                  // User info
                  Text(
                    user.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(AppConstants.smallPadding),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const Gap(AppConstants.smallPadding),

                  // Email verification status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: user.isEmailVerified
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.isEmailVerified ? 'Verified' : 'Not Verified',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: user.isEmailVerified
                            ? colorScheme.primary
                            : colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(AppConstants.defaultPadding),

            // Account details
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppConstants.defaultPadding),

                  _buildDetailRow(
                    context,
                    'Phone Number',
                    user.phoneNumber ?? 'Not provided',
                    Icons.phone,
                  ),
                  const Gap(AppConstants.smallPadding),
                  _buildDetailRow(
                    context,
                    'Member Since',
                    user.createdAt.formatDate,
                    Icons.calendar_today,
                  ),
                  if (user.updatedAt != null) ...[
                    const Gap(AppConstants.smallPadding),
                    _buildDetailRow(
                      context,
                      'Last Updated',
                      user.updatedAt!.formatDate,
                      Icons.update,
                    ),
                  ],
                ],
              ),
            ),

            const Gap(AppConstants.defaultPadding),

            // Actions
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(AppConstants.defaultPadding),

                  if (!user.isEmailVerified)
                    AppButton(
                      text: 'Verify Email',
                      onPressed: () => _verifyEmail(context, ref),
                      variant: AppButtonVariant.secondary,
                      icon: Icons.mark_email_read,
                      width: double.infinity,
                    ),

                  if (!user.isEmailVerified)
                    const Gap(AppConstants.smallPadding),

                  AppButton(
                    text: 'Change Password',
                    onPressed: () => _showChangePasswordDialog(context, ref),
                    variant: AppButtonVariant.secondary,
                    icon: Icons.lock_reset,
                    width: double.infinity,
                  ),
                  const Gap(AppConstants.smallPadding),

                  AppButton(
                    text: 'Sign Out',
                    onPressed: () => _signOut(context, ref),
                    variant: AppButtonVariant.destructive,
                    icon: Icons.logout,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (authState is Unauthenticated) {
      return const Center(child: Text('Please sign in to view your profile'));
    }

    if (authState is AuthError) {
      return AppErrorWidget(
        message: authState.message,
        onRetry: () => ref.read(authStateProvider.notifier).refresh(),
      );
    }

    return const Center(child: Text('Unknown state'));
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    // TODO(username): Implement edit profile dialog
    context.showSnackBar('Edit profile coming soon!');
  }

  void _verifyEmail(BuildContext context, WidgetRef ref) {
    // TODO(username): Implement email verification
    context.showSnackBar('Email verification coming soon!');
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    // TODO(username): Implement change password dialog
    context.showSnackBar('Change password coming soon!');
  }

  void _signOut(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStateProvider.notifier).signOut();
              context.go('/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

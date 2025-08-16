// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// Project imports:
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

/// Notification Settings Page
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  String? _fcmToken;
  bool _isLoading = false;
  final List<String> _subscribedTopics = [];

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
  }

  Future<void> _loadFCMToken() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(pushNotificationServiceProvider);
      final token = await service.getToken();
      setState(() => _fcmToken = token);
    } on Exception catch (e) {
      _showErrorSnackBar('Failed to load FCM token: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _copyTokenToClipboard() async {
    if (_fcmToken != null) {
      await Clipboard.setData(ClipboardData(text: _fcmToken!));
      _showSuccessSnackBar('FCM token copied to clipboard');
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(pushNotificationServiceProvider);
      await service.subscribeToTopic(topic);
      setState(() => _subscribedTopics.add(topic));
      _showSuccessSnackBar('Subscribed to $topic');
    } on Exception catch (e) {
      _showErrorSnackBar('Failed to subscribe to $topic: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(pushNotificationServiceProvider);
      await service.unsubscribeFromTopic(topic);
      setState(() => _subscribedTopics.remove(topic));
      _showSuccessSnackBar('Unsubscribed from $topic');
    } on Exception catch (e) {
      _showErrorSnackBar('Failed to unsubscribe from $topic: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notification Settings'), elevation: 0),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFCMTokenSection(),
                const Gap(24),
                _buildTopicSubscriptionSection(),
                const Gap(24),
                _buildTestNotificationSection(),
              ],
            ),
          ),
  );

  Widget _buildFCMTokenSection() => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FCM Token',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Gap(12),
        const Text(
          'This token uniquely identifies this device for push notifications.',
          style: TextStyle(color: Colors.grey),
        ),
        const Gap(16),
        if (_fcmToken != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              _fcmToken!,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const Gap(12),
          AppButton(
            text: 'Copy Token',
            onPressed: _copyTokenToClipboard,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
          ),
        ] else
          const Text('No FCM token available'),
      ],
    ),
  );

  Widget _buildTopicSubscriptionSection() {
    const availableTopics = ['news', 'updates', 'promotions', 'alerts'];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Topic Subscriptions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Gap(12),
          const Text(
            'Subscribe to topics to receive targeted notifications.',
            style: TextStyle(color: Colors.grey),
          ),
          const Gap(16),
          ...availableTopics.map((topic) {
            final isSubscribed = _subscribedTopics.contains(topic);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  AppButton(
                    text: isSubscribed ? 'Unsubscribe' : 'Subscribe',
                    onPressed: () => isSubscribed
                        ? _unsubscribeFromTopic(topic)
                        : _subscribeToTopic(topic),
                    variant: isSubscribed
                        ? AppButtonVariant.secondary
                        : AppButtonVariant.primary,
                    size: AppButtonSize.small,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTestNotificationSection() => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Test Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Gap(12),
        const Text(
          'Send test notifications to verify your setup.',
          style: TextStyle(color: Colors.grey),
        ),
        const Gap(16),
        const Text(
          'To test push notifications:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        const Text(
          '1. Copy your FCM token above\n'
          '2. Go to Firebase Console > Cloud Messaging\n'
          '3. Create a new campaign or send a test message\n'
          '4. Paste your FCM token as the target',
          style: TextStyle(color: Colors.grey),
        ),
        const Gap(16),
        AppButton(
          text: 'Open Firebase Console',
          onPressed: () {
            _showSuccessSnackBar(
              'Visit: https://console.firebase.google.com/project/fluttertemplate-74068/messaging',
            );
          },
          variant: AppButtonVariant.secondary,
        ),
      ],
    ),
  );
}

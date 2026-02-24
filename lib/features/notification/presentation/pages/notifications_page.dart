import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/notification/presentation/state/notification_state.dart';
import 'package:hamro_deal/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hamro_deal/features/notification/presentation/widgets/notification_card.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(notificationViewModelProvider.notifier).refresh();
  }

  void _showDeleteConfirmation(String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text(
          'Are you sure you want to delete this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(notificationViewModelProvider.notifier)
                  .deleteNotification(notificationId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(notificationViewModelProvider.notifier)
                  .deleteAllNotifications();
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notificationState.unreadCount > 0)
            IconButton(
              onPressed: () {
                ref
                    .read(notificationViewModelProvider.notifier)
                    .markAllAsRead();
              },
              icon: const Icon(Icons.done_all),
            ),
          // delete
          if (notificationState.notifications.isNotEmpty)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete All'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _buildBody(notificationState),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state.status == NotificationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NotificationStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'Failed to load notifications',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length,
        itemBuilder: (context, index) {
          final notification = state.notifications[index];
          return NotificationCard(
            notification: notification,
            onTap: () {
              // Mark as read when tapped
              if (!notification.isRead) {
                ref
                    .read(notificationViewModelProvider.notifier)
                    .markAsRead(notification.id);
              }
              // TODO: Navigate to related page if actionUrl exists
            },
            onDelete: () => _showDeleteConfirmation(notification.id),
          );
        },
      ),
    );
  }
}

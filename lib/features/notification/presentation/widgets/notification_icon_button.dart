import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/notification/presentation/pages/notifications_page.dart';
import 'package:hamro_deal/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hamro_deal/features/notification/presentation/widgets/notification_badge.dart';

class NotificationIconButton extends ConsumerStatefulWidget {
  const NotificationIconButton({super.key});

  @override
  ConsumerState<NotificationIconButton> createState() =>
      _NotificationIconButtonState();
}

class _NotificationIconButtonState
    extends ConsumerState<NotificationIconButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).loadUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return NotificationBadge(
      count: notificationState.unreadCount,
      child: IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        },
      ),
    );
  }
}

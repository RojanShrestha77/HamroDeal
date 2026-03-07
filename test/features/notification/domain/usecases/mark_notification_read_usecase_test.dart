import 'package:flutter_test/flutter_test.dart';

class NotificationItem {
  final String id;
  bool isRead;

  NotificationItem({required this.id, required this.isRead});
}

class MarkNotificationReadUseCase {
  void call(List<NotificationItem> notifications, String notificationId) {
    final notification = notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => NotificationItem(id: '', isRead: false),
    );
    if (notification.id.isNotEmpty) {
      notification.isRead = true;
    }
  }
}

void main() {
  group('MarkNotificationReadUseCase', () {
    late MarkNotificationReadUseCase useCase;
    late List<NotificationItem> notifications;

    setUp(() {
      useCase = MarkNotificationReadUseCase();
      notifications = [
        NotificationItem(id: '1', isRead: false),
        NotificationItem(id: '2', isRead: false),
        NotificationItem(id: '3', isRead: true),
      ];
    });

    test('marks notification as read', () {
      useCase(notifications, '1');
      expect(notifications[0].isRead, true);
    });

    test('keeps other notifications unchanged', () {
      useCase(notifications, '1');
      expect(notifications[1].isRead, false);
      expect(notifications[2].isRead, true);
    });

    test('handles non-existent notification', () {
      useCase(notifications, '999');
      expect(notifications[0].isRead, false);
    });

    test('marks multiple notifications', () {
      useCase(notifications, '1');
      useCase(notifications, '2');
      expect(notifications[0].isRead, true);
      expect(notifications[1].isRead, true);
    });

    test('idempotent operation', () {
      useCase(notifications, '1');
      useCase(notifications, '1');
      expect(notifications[0].isRead, true);
    });
  });
}

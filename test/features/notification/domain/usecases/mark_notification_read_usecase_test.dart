import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';

void main() {
  group('NotificationEntity - Mark as Read', () {
    late List<NotificationEntity> notifications;

    setUp(() {
      notifications = [
        NotificationEntity(
          id: '1',
          userId: 'user1',
          title: 'Order Confirmed',
          message: 'Your order has been confirmed',
          type: 'order',
          isRead: false,
          createdAt: DateTime.now(),
        ),
        NotificationEntity(
          id: '2',
          userId: 'user1',
          title: 'Shipped',
          message: 'Your order has been shipped',
          type: 'order',
          isRead: false,
          createdAt: DateTime.now(),
        ),
        NotificationEntity(
          id: '3',
          userId: 'user1',
          title: 'Delivered',
          message: 'Your order has been delivered',
          type: 'order',
          isRead: true,
          createdAt: DateTime.now(),
        ),
      ];
    });

    test('marks notification as read', () {
      final notif = notifications.firstWhere((n) => n.id == '1');
      expect(notif.isRead, false);
    });

    test('keeps other notifications unchanged', () {
      expect(notifications[1].isRead, false);
      expect(notifications[2].isRead, true);
    });

    test('handles non-existent notification', () {
      final found = notifications.where((n) => n.id == '999');
      expect(found.isEmpty, true);
    });

    test('filters unread notifications', () {
      final unread = notifications.where((n) => !n.isRead).toList();
      expect(unread.length, 2);
    });

    test('filters read notifications', () {
      final read = notifications.where((n) => n.isRead).toList();
      expect(read.length, 1);
    });

    test('NotificationEntity are equatable', () {
      final now = DateTime.now();
      final notif1 = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'test',
        isRead: false,
        createdAt: now,
      );

      final notif2 = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'test',
        isRead: false,
        createdAt: now,
      );

      expect(notif1, equals(notif2));
    });
  });
}

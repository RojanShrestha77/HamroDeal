import 'package:flutter_test/flutter_test.dart';

class Notification {
  final String id;
  final String type;
  final bool isRead;

  Notification({
    required this.id,
    required this.type,
    required this.isRead,
  });
}

class FilterNotificationsUseCase {
  List<Notification> call(List<Notification> notifications, {bool? isRead}) {
    if (isRead == null) return notifications;
    return notifications.where((n) => n.isRead == isRead).toList();
  }
}

void main() {
  group('FilterNotificationsUseCase', () {
    late FilterNotificationsUseCase useCase;
    late List<Notification> notifications;

    setUp(() {
      useCase = FilterNotificationsUseCase();
      notifications = [
        Notification(id: '1', type: 'order', isRead: true),
        Notification(id: '2', type: 'message', isRead: false),
        Notification(id: '3', type: 'order', isRead: false),
      ];
    });

    test('returns all notifications when no filter', () {
      expect(useCase(notifications).length, 3);
    });

    test('returns only read notifications', () {
      expect(useCase(notifications, isRead: true).length, 1);
    });

    test('returns only unread notifications', () {
      expect(useCase(notifications, isRead: false).length, 2);
    });

    test('returns empty list for empty notifications', () {
      expect(useCase([], isRead: true).length, 0);
    });

    test('filters correctly with multiple notifications', () {
      final result = useCase(notifications, isRead: false);
      expect(result.every((n) => !n.isRead), true);
    });
  });
}

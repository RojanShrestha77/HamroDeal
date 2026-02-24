import 'package:hamro_deal/features/notification/data/model/notification_model.dart';

abstract class INotificationDataSource {
  Future<List<NotificationModel>> getAllNotifications({
    required int page,
    required int size,
  });

  Future<int> getUnreadCount();

  Future<NotificationModel> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(String notificationId);

  Future<void> deleteAllNotifications();
}

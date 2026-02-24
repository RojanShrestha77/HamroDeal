import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationRepository {
  Future<Either<ApiFailure, List<NotificationEntity>>> getAllNotifications({
    required int page,
    required int size,
  });

  Future<Either<ApiFailure, int>> getUnreadCount();

  Future<Either<ApiFailure, NotificationEntity>> markAsRead(
    String notificationId,
  );

  Future<Either<ApiFailure, void>> markAllAsRead();

  Future<Either<ApiFailure, void>> deleteNotification(String notificationId);

  Future<Either<ApiFailure, void>> deleteAllNotifications();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';
import 'package:hamro_deal/features/notification/domain/usecases/delete_al_notification_usecase.dart';
import 'package:hamro_deal/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:hamro_deal/features/notification/domain/usecases/get_all_notification_usecase.dart';
import 'package:hamro_deal/features/notification/domain/usecases/get_unread_count_usecase.dart';
import 'package:hamro_deal/features/notification/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:hamro_deal/features/notification/domain/usecases/mark_as_read_usecase.dart';
import 'package:hamro_deal/features/notification/presentation/state/notification_state.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      () => NotificationViewModel(),
    );

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetAllNotificationsUsecase _getAllNotificationsUsecase;
  late final GetUnreadCountUsecase _getUnreadCountUsecase;
  late final MarkAsReadUsecase _markAsReadUsecase;
  late final MarkAllAsReadUsecase _markAllAsReadUsecase;
  late final DeleteNotificationUsecase _deleteNotificationUsecase;
  late final DeleteAllNotificationsUsecase _deleteAllNotificationsUsecase;

  @override
  NotificationState build() {
    _getAllNotificationsUsecase = ref.read(getAllNotificationsUsecaseProvider);
    _getUnreadCountUsecase = ref.read(getUnreadCountUsecaseProvider);
    _markAsReadUsecase = ref.read(markAsReadUsecaseProvider);
    _markAllAsReadUsecase = ref.read(markAllAsReadUsecaseProvider);
    _deleteNotificationUsecase = ref.read(deleteNotificationUsecaseProvider);
    _deleteAllNotificationsUsecase = ref.read(
      deleteAllNotificationsUsecaseProvider,
    );

    return NotificationState.initial();
  }

  Future<void> loadNotifications({int page = 1, int size = 20}) async {
    state = state.copyWith(status: NotificationStatus.loading);

    final params = GetAllNotificationsParams(page: page, size: size);
    final result = await _getAllNotificationsUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: NotificationStatus.error,
          error: failure.message,
        );
      },
      (notifications) {
        state = state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          clearError: true,
        );
        loadUnreadCount();
      },
    );
  }

  Future<void> loadUnreadCount() async {
    final result = await _getUnreadCountUsecase();

    result.fold(
      (failure) {
        // Silently fail for unread count
      },
      (count) {
        state = state.copyWith(unreadCount: count);
      },
    );
  }

  Future<bool> markAsRead(String notificationId) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final params = MarkAsReadParams(notificationId: notificationId);
    final result = await _markAsReadUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (updatedNotification) {
        final updatedList = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return updatedNotification;
          }
          return notification;
        }).toList();

        state = state.copyWith(
          isActionLoading: false,
          notifications: updatedList,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> markAllAsRead() async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final result = await _markAllAsReadUsecase();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (_) {
        final updatedList = state.notifications.map((notification) {
          return NotificationEntity(
            id: notification.id,
            userId: notification.userId,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            isRead: true,
            relatedId: notification.relatedId,
            actionUrl: notification.actionUrl,
            createdAt: notification.createdAt,
          );
        }).toList();

        state = state.copyWith(
          isActionLoading: false,
          notifications: updatedList,
          unreadCount: 0,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteNotification(String notificationId) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final params = DeleteNotificationParams(notificationId: notificationId);
    final result = await _deleteNotificationUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (_) {
        final deletedNotification = state.notifications.firstWhere(
          (notification) => notification.id == notificationId,
        );
        final updatedList = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();

        final newUnreadCount = deletedNotification.isRead
            ? state.unreadCount
            : (state.unreadCount > 0 ? state.unreadCount - 1 : 0);

        state = state.copyWith(
          isActionLoading: false,
          notifications: updatedList,
          unreadCount: newUnreadCount,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteAllNotifications() async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final result = await _deleteAllNotificationsUsecase();

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isActionLoading: false,
          notifications: [],
          unreadCount: 0,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<void> refresh() async {
    await loadNotifications();
  }
}

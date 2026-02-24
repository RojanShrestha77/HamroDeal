import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';

enum NotificationStatus { initial, loading, success, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? error;
  final bool isActionLoading;
  final String? actionError;

  const NotificationState({
    required this.status,
    required this.notifications,
    required this.unreadCount,
    this.error,
    required this.isActionLoading,
    this.actionError,
  });

  factory NotificationState.initial() {
    return const NotificationState(
      status: NotificationStatus.initial,
      notifications: [],
      unreadCount: 0,
      isActionLoading: false,
    );
  }

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? error,
    bool? isActionLoading,
    String? actionError,
    bool clearError = false,
    bool clearActionError = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      error: clearError ? null : (error ?? this.error),
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    unreadCount,
    error,
    isActionLoading,
    actionError,
  ];
}

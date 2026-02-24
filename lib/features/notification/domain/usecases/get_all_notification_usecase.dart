import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/notification/data/respositories/notification_repository.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';
import 'package:hamro_deal/features/notification/domain/repositories/notification_repository.dart';

class GetAllNotificationsParams extends Equatable {
  final int page;
  final int size;

  const GetAllNotificationsParams({required this.page, required this.size});

  @override
  List<Object?> get props => [page, size];
}

final getAllNotificationsUsecaseProvider = Provider<GetAllNotificationsUsecase>(
  (ref) {
    final repository = ref.read(notificationRepositoryProvider);
    return GetAllNotificationsUsecase(repository: repository);
  },
);

class GetAllNotificationsUsecase
    implements
        UsecaseWithParams<List<NotificationEntity>, GetAllNotificationsParams> {
  final INotificationRepository _repository;

  GetAllNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetAllNotificationsParams params,
  ) {
    return _repository.getAllNotifications(
      page: params.page,
      size: params.size,
    );
  }
}

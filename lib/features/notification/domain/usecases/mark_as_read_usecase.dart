import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/notification/data/respositories/notification_repository.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';
import 'package:hamro_deal/features/notification/domain/repositories/notification_repository.dart';

class MarkAsReadParams extends Equatable {
  final String notificationId;

  const MarkAsReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

final markAsReadUsecaseProvider = Provider<MarkAsReadUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return MarkAsReadUsecase(repository: repository);
});

class MarkAsReadUsecase
    implements UsecaseWithParams<NotificationEntity, MarkAsReadParams> {
  final INotificationRepository _repository;

  MarkAsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NotificationEntity>> call(MarkAsReadParams params) {
    return _repository.markAsRead(params.notificationId);
  }
}

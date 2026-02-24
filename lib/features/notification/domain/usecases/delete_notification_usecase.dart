import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/notification/data/respositories/notification_repository.dart';
import 'package:hamro_deal/features/notification/domain/repositories/notification_repository.dart';

class DeleteNotificationParams extends Equatable {
  final String notificationId;

  const DeleteNotificationParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

final deleteNotificationUsecaseProvider = Provider<DeleteNotificationUsecase>((
  ref,
) {
  final repository = ref.read(notificationRepositoryProvider);
  return DeleteNotificationUsecase(repository: repository);
});

class DeleteNotificationUsecase
    implements UsecaseWithParams<void, DeleteNotificationParams> {
  final INotificationRepository _repository;

  DeleteNotificationUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteNotificationParams params) {
    return _repository.deleteNotification(params.notificationId);
  }
}

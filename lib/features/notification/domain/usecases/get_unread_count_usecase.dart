import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/notification/data/respositories/notification_repository.dart';
import 'package:hamro_deal/features/notification/domain/repositories/notification_repository.dart';

final getUnreadCountUsecaseProvider = Provider<GetUnreadCountUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetUnreadCountUsecase(repository: repository);
});

class GetUnreadCountUsecase implements UsecaseWithoutParams<int> {
  final INotificationRepository _repository;

  GetUnreadCountUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, int>> call() {
    return _repository.getUnreadCount();
  }
}

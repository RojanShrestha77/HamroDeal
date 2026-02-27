import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class ResetUnreadCountParams extends Equatable {
  final String id;

  const ResetUnreadCountParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final resetUnreadCountUsecaseProvider = Provider<ResetUnreadCountUsecase>((
  ref,
) {
  final repository = ref.read(messagingRepositoryProvider);
  return ResetUnreadCountUsecase(repository: repository);
});

class ResetUnreadCountUsecase
    implements UsecaseWithParams<void, ResetUnreadCountParams> {
  final IMessagingRepository _repository;

  ResetUnreadCountUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(ResetUnreadCountParams params) {
    return _repository.resetUnreadCount(params.id);
  }
}

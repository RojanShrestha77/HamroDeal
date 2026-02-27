import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class MarkMessagesAsReadParams extends Equatable {
  final String conversationId;

  const MarkMessagesAsReadParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

final markMessagesAsReadUsecaseProvider = Provider<MarkMessagesAsReadUsecase>((
  ref,
) {
  final repository = ref.read(messagingRepositoryProvider);
  return MarkMessagesAsReadUsecase(repository: repository);
});

class MarkMessagesAsReadUsecase
    implements UsecaseWithParams<void, MarkMessagesAsReadParams> {
  final IMessagingRepository _repository;

  MarkMessagesAsReadUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(MarkMessagesAsReadParams params) {
    return _repository.markMessagesAsRead(params.conversationId);
  }
}

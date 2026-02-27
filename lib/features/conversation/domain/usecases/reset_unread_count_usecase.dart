import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class DeleteConversationParams extends Equatable {
  final String id;

  const DeleteConversationParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteConversationUsecaseProvider = Provider<DeleteConversationUsecase>((
  ref,
) {
  final repository = ref.read(messagingRepositoryProvider);
  return DeleteConversationUsecase(repository: repository);
});

class DeleteConversationUsecase
    implements UsecaseWithParams<void, DeleteConversationParams> {
  final IMessagingRepository _repository;

  DeleteConversationUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteConversationParams params) {
    return _repository.deleteConversation(params.id);
  }
}

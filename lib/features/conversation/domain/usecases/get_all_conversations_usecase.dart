import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

final getAllConversationsUsecaseProvider = Provider<GetAllConversationsUsecase>(
  (ref) {
    final repository = ref.read(messagingRepositoryProvider);
    return GetAllConversationsUsecase(repository: repository);
  },
);

class GetAllConversationsUsecase
    implements UsecaseWithoutParams<List<ConversationEntity>> {
  final IMessagingRepository _repository;

  GetAllConversationsUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ConversationEntity>>> call() {
    return _repository.getAllConversations();
  }
}

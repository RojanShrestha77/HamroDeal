import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class GetConversationMessagesParams extends Equatable {
  final String conversationId;

  const GetConversationMessagesParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

final getConversationMessagesUsecaseProvider =
    Provider<GetConversationMessagesUsecase>((ref) {
      final repository = ref.read(messagingRepositoryProvider);
      return GetConversationMessagesUsecase(repository: repository);
    });

class GetConversationMessagesUsecase
    implements
        UsecaseWithParams<List<MessageEntity>, GetConversationMessagesParams> {
  final IMessagingRepository _repository;

  GetConversationMessagesUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
    GetConversationMessagesParams params,
  ) {
    return _repository.getConversationMessages(params.conversationId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;

  const SendMessageParams({
    required this.conversationId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, content];
}

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return SendMessageUsecase(repository: repository);
});

class SendMessageUsecase
    implements UsecaseWithParams<MessageEntity, SendMessageParams> {
  final IMessagingRepository _repository;

  SendMessageUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return _repository.sendMessage(params.conversationId, params.content);
  }
}

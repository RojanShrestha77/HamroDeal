import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class CreateOrGetConversationParams extends Equatable {
  final String sellerId;

  const CreateOrGetConversationParams({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

final createOrGetConversationUsecaseProvider =
    Provider<CreateOrGetConversationUsecase>((ref) {
      final repository = ref.read(messagingRepositoryProvider);
      return CreateOrGetConversationUsecase(repository: repository);
    });

class CreateOrGetConversationUsecase
    implements
        UsecaseWithParams<ConversationEntity, CreateOrGetConversationParams> {
  final IMessagingRepository _repository;

  CreateOrGetConversationUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ConversationEntity>> call(
    CreateOrGetConversationParams params,
  ) {
    return _repository.createOrGetConversation(params.sellerId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class GetConversationByIdParams extends Equatable {
  final String id;

  const GetConversationByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getConversationByIdUsecaseProvider = Provider<GetConversationByIdUsecase>(
  (ref) {
    final repository = ref.read(messagingRepositoryProvider);
    return GetConversationByIdUsecase(repository: repository);
  },
);

class GetConversationByIdUsecase
    implements
        UsecaseWithParams<ConversationEntity, GetConversationByIdParams> {
  final IMessagingRepository _repository;

  GetConversationByIdUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ConversationEntity>> call(
    GetConversationByIdParams params,
  ) {
    return _repository.getConversationById(params.id);
  }
}

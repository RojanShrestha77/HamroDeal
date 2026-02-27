import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/conversation/data/repositories/messaging_repository.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

class DeleteMessageParams extends Equatable {
  final String id;

  const DeleteMessageParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteMessageUsecaseProvider = Provider<DeleteMessageUsecase>((ref) {
  final repository = ref.read(messagingRepositoryProvider);
  return DeleteMessageUsecase(repository: repository);
});

class DeleteMessageUsecase
    implements UsecaseWithParams<void, DeleteMessageParams> {
  final IMessagingRepository _repository;

  DeleteMessageUsecase({required IMessagingRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteMessageParams params) {
    return _repository.deleteMessage(params.id);
  }
}

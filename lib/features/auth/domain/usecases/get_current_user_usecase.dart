import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository.dart';

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

class GetCurrentUserUseCase {
  final IAuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, AuthEntity?>> call() async {
    return await _repository.getCurrentUser();
  }
}

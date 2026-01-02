import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository_impl.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, bool>> call(AuthEntity entity) {
    return repository.register(entity);
  }
}

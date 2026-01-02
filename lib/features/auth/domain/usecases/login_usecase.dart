import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository_impl.dart';

/// Provider for LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Login UseCase
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executes login
  ///
  /// Returns:
  /// - Right(AuthEntity) on success
  /// - Left(Failure) on error
  Future<Either<Failure, AuthEntity>> call(
    String email,
    String password,
  ) async {
    return await _repository.login(email, password);
  }
}

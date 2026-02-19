import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/users/data/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/admin/users/domain/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

final updateUserUsecaseProvider = Provider<UpdateUserUsecase>((ref) {
  return UpdateUserUsecase(repository: ref.read(adminUserRepositoryProvider));
});

class UpdateUserUsecase {
  final IAdminUserRepository _repository;

  UpdateUserUsecase({required IAdminUserRepository repository})
    : _repository = repository;

  Future<Either<Failure, AuthEntity>> call(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await _repository.updateUser(userId, data);
  }
}

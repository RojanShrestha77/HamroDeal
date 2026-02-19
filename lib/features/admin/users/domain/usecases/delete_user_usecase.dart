import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/users/data/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/admin/users/domain/repositories/admin_user_repository.dart';

final deleteUserUsecaseProvider = Provider<DeleteUserUsecase>((ref) {
  return DeleteUserUsecase(repository: ref.read(adminUserRepositoryProvider));
});

class DeleteUserUsecase {
  final IAdminUserRepository _repository;

  DeleteUserUsecase({required IAdminUserRepository repository})
    : _repository = repository;

  Future<Either<Failure, void>> call(String userId) async {
    return await _repository.deleteUser(userId);
  }
}

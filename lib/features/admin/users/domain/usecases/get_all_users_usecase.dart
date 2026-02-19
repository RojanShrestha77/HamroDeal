import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/users/data/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/admin/users/domain/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

final getAllUsersUsecaseProvider = Provider<GetAllUsersUsecase>((ref) {
  return GetAllUsersUsecase(repository: ref.read(adminUserRepositoryProvider));
});

class GetAllUsersUsecase {
  final IAdminUserRepository _repository;

  GetAllUsersUsecase({required IAdminUserRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<AuthEntity>>> call() async {
    return await _repository.getAllUsers();
  }
}

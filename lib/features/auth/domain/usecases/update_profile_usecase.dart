import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(repository: ref.read(authRepositoryProvider));
});

class UpdateProfileUsecaseParams {
  final String? firstName;
  final String? lastName;
  final String? email;

  UpdateProfileUsecaseParams({this.firstName, this.lastName, this.email});
}

class UpdateProfileUsecase {
  final IAuthRepository _repository;

  UpdateProfileUsecase({required IAuthRepository repository})
    : _repository = repository;

  Future<Either<Failure, AuthEntity>> call(
    UpdateProfileUsecaseParams params,
  ) async {
    return await _repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String email;
  final String username;
  final String password;
  final String? imageUrl;

  const RegisterUsecaseParams({
    this.firstName,
    this.lastName,
    required this.email,
    required this.username,
    required this.password,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    username,
    password,
    imageUrl,
  ];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      email: params.email,
      password: params.password,
      imageUrl: params.imageUrl,
    );
    return _authRepository.register(entity);
  }
}

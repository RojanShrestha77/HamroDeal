// hamro_deal/lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecaseParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordUsecaseParams({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

// provider for ResetPasswordUsecase
final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ResetPasswordUsecase(authRepository: authRepository);
});

class ResetPasswordUsecase
    implements UsecaseWithParams<bool, ResetPasswordUsecaseParams> {
  final IAuthRepository _authRepository;

  ResetPasswordUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(ResetPasswordUsecaseParams params) {
    return _authRepository.resetPassword(params.token, params.newPassword);
  }
}

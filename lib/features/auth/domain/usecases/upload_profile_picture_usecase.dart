import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/usecases/upload_photo_usecase.dart';

final uploadProfilePictureUsecaseProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadProfilePictureUsecase(authRepository: authRepository);
});

class UploadProfilePictureUsecase implements UsecaseWithParams<String, File> {
  final IAuthRepository _authRepository;
  UploadProfilePictureUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _authRepository.uploadProfilePicture(photo);
  }
}

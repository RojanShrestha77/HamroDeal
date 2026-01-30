import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, String>> uploadProfilePicture(File photo);
}

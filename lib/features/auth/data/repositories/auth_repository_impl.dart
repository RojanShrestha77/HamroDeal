import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authLocalDatasourceProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, bool>> register(AuthEntity authEntity) async {
    try {
      final model = AuthHiveModel.fromEntity(authEntity);
      final result = await _dataSource.register(model);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _dataSource.login(email, password);
      if (model != null) {
        return Right(model.toEntity());
      }
      return Left(LocalDatabaseFailure(message: 'Invalid credentials'));
    } catch (e) {
      return Left(LocalDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      final model = await _dataSource.getCurrentUser();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _dataSource.logout();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailExists(String email) async {
    try {
      final result = await _dataSource.isEmailExists(email);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure());
    }
  }
}

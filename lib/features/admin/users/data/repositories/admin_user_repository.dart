import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/admin/users/data/datasource/admin_user_datasource.dart';
import 'package:hamro_deal/features/admin/users/data/datasource/remote/admin_user_remote_datasource.dart';
import 'package:hamro_deal/features/admin/users/domain/repositories/admin_user_repository.dart';
import 'package:hamro_deal/features/auth/data/models/auth_api_model.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

final adminUserRepositoryProvider = Provider<IAdminUserRepository>((ref) {
  return AdminUserRepository(
    remoteDataSource: ref.read(adminUserRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class AdminUserRepository implements IAdminUserRepository {
  final IAdminUserDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminUserRepository({
    required IAdminUserDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<AuthEntity>>> getAllUsers() async {
    if (await _networkInfo.isConnected) {
      try {
        final users = await _remoteDataSource.getAllUsers();
        return Right(users.map((model) => model.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch users',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getUserById(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserById(userId);
        return Right(user.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch user',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserDetails(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final details = await _remoteDataSource.getUserDetails(userId);
        return Right(details);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to fetch user details',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> createUser(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = AuthApiModel.fromEntity(user);
        final createdUser = await _remoteDataSource.createUser(userModel);
        return Right(createdUser.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to create user',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedUser = await _remoteDataSource.updateUser(userId, data);
        return Right(updatedUser.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to update user',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteUser(userId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to delete user',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> approveSeller(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final approvedUser = await _remoteDataSource.approveSeller(userId);
        return Right(approvedUser.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to approve seller',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

abstract class IAdminUserRepository {
  Future<Either<Failure, List<AuthEntity>>> getAllUsers();
  Future<Either<Failure, AuthEntity>> getUserById(String userId);
  Future<Either<Failure, Map<String, dynamic>>> getUserDetails(String userId);
  Future<Either<Failure, AuthEntity>> createUser(AuthEntity user);
  Future<Either<Failure, AuthEntity>> updateUser(String userId, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteUser(String userId);
  Future<Either<Failure, AuthEntity>> approveSeller(String userId);
}

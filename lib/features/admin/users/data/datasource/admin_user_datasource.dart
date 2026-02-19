import 'package:hamro_deal/features/auth/data/models/auth_api_model.dart';

abstract class IAdminUserDataSource {
  Future<List<AuthApiModel>> getAllUsers();
  Future<AuthApiModel> getUserById(String userId);
  Future<Map<String, dynamic>> getUserDetails(String userId);
  Future<AuthApiModel> createUser(AuthApiModel user);
  Future<AuthApiModel> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
  Future<AuthApiModel> approveSeller(String userId);
}

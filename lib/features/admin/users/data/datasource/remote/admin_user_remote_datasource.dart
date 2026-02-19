import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/admin/users/data/datasource/admin_user_datasource.dart';
import 'package:hamro_deal/features/auth/data/models/auth_api_model.dart';

final adminUserRemoteDatasourceProvider = Provider<IAdminUserDataSource>((ref) {
  return AdminUserRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AdminUserRemoteDataSource implements IAdminUserDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AdminUserRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<AuthApiModel>> getAllUsers() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminUsers,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data['data'] as List;
    return data.map((json) => AuthApiModel.fromJson(json)).toList();
  }

  @override
  Future<AuthApiModel> getUserById(String userId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminUserById(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AuthApiModel.fromJson(response.data['data']);
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminUserDetails(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<AuthApiModel> createUser(AuthApiModel user) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.adminUsers,
      data: user.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AuthApiModel.fromJson(response.data['data']);
  }

  @override
  Future<AuthApiModel> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.put(
      ApiEndpoints.adminUpdateUser(userId),
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AuthApiModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.adminDeleteUser(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<AuthApiModel> approveSeller(String userId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.adminApproveSeller(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AuthApiModel.fromJson(response.data['data']);
  }
}

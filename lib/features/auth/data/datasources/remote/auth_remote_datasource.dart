import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/features/auth/data/datasources/auth_datasource.dart';
import 'package:hamro_deal/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _userSessionService = userSessionService,
       _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.whoami,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.userId!,
        email: user.email,
        fullName: '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
        username: user.username,
        profileImage: user.imageUrl,
        role: user.role,
        isApproved: user.isApproved,
      );

      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registerUser = AuthApiModel.fromJson(data);
      return registerUser;
    }
    return user;
  }

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final token = _tokenService.getToken();

    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    var imageUrl = response.data['data']['imageUrl'];
    return imageUrl;
  }

  @override
  Future<AuthApiModel> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    final token = _tokenService.getToken();

    final data = <String, dynamic>{};
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (email != null) data['email'] = email;

    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AuthApiModel.fromJson(response.data['data']);
  }
}

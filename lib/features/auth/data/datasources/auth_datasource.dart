import 'dart:io';

import 'package:hamro_deal/features/auth/data/models/auth_api_model.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<bool> isEmailExists(String email);
}

abstract interface class IAuthRemoteDatasource {
  Future<String> uploadImage(File image);
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
}

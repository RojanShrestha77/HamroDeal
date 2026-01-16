import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/hive_service.dart';
import 'package:hamro_deal/features/auth/data/datasources/auth_datasource.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';

// provider
final authLocalDatasourceProvider = Provider((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;
  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExists(String email) {
    try{
      final exists = _hiveService.isEmailExists(email);
      return Future.value(exists);
    } catch(e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}

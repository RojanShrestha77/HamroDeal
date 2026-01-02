import 'package:hamro_deal/core/services/hive_service.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource(ref.watch(hiveServiceProvider));
});

class AuthLocalDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource(this._hiveService);

  Future<bool> register(AuthHiveModel model) async {
    if (_hiveService.isEmailExists(model.email)) {
      return false;
    }
    await _hiveService.registerUser(model);
    return true;
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    return await _hiveService.loginUser(email, password);
  }

  Future<AuthHiveModel?> getCurrentUser() async {
    return await _hiveService.getCurrentUser();
  }

  Future<bool> logout() async {
    await _hiveService.logoutUser();
    return true;
  }

  Future<bool> isEmailExists(String email) async {
    return _hiveService.isEmailExists(email);
  }
}

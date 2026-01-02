import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthHiveModelAdapter());

    await Hive.openBox<AuthHiveModel>(HiveTableConstants.authTable);
    await Hive.openBox(HiveTableConstants.settingsBox);
  }

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);
  Box get _settingsBox => Hive.box(HiveTableConstants.settingsBox);

  // Register user
  Future<bool> registerUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.email)) return false;
    await _authBox.put(user.email, user);
    await _settingsBox.put(HiveTableConstants.currentUserKey, user.email);
    return true;
  }

  // Login user
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final user = _authBox.get(email);

    // Clear any previous logged in user if login fails
    if (user == null || user.password != password) {
      await _settingsBox.delete(HiveTableConstants.currentUserKey);
      return null;
    }

    // Login success → store current user
    await _settingsBox.put(HiveTableConstants.currentUserKey, email);
    return user;
  }

  Future<AuthHiveModel?> getCurrentUser() async {
    final currentEmail = _settingsBox.get(HiveTableConstants.currentUserKey);
    return currentEmail != null ? _authBox.get(currentEmail) : null;
  }

  Future<void> logoutUser() async {
    await _settingsBox.delete(HiveTableConstants.currentUserKey);
  }

  bool isEmailExists(String email) => _authBox.containsKey(email);
}

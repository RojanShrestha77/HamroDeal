import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/hive/hive_service.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/features/auth/data/datasources/auth_datasource.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isEmailExists(String email) {
    try {
      final exists = _hiveService.isEmailExists(email);
      return Future.value(exists);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        // Combine firstName and lastName for fullName
        final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'
            .trim();

        await _userSessionService.saveUserSession(
          userId: user.userId!,
          email: user.email,
          fullName: fullName,
          username: user.userName,
          profileImage: user.imageUrl,
          role: user.role,
          isApproved: user.isApproved,
        );
      }
      return user;
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

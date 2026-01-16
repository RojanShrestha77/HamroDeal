import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstants.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }
  // Register Adapter
  // Open Boxes
  // close Boxes
  // Queries

  // Register Adapter
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.authTable);
  }

  // close boxes
  Future<void> close() async {
    await Hive.close();
  }

  // =============== Auth QUERIES  ================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);

  // register
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  // login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // logout
  Future<void> logoutUser() async {}

  // get user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // is email exists
  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }
}

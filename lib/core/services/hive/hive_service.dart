import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';
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

  // ====================== product queries ===================

  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>(HiveTableConstants.productTable);

  Future<ProductHiveModel> createProduct(ProductHiveModel product) async {
    await _productBox.put(product.productId, product);
    return product;
  }

  List<ProductHiveModel> getAllProducts() {
    return _productBox.values.toList();
  }

  ProductHiveModel? getProductById(String productId) {
    return _productBox.get(productId);
  }

  List<ProductHiveModel> getProductsByUser(String userId) {
    return _productBox.values.where((product) => product.id == userId).toList();
  }

  List<ProductHiveModel> getProductsByCategory(String categoryid) {
    return _productBox.values
        .where((product) => product.category == categoryid)
        .toList();
  }

  Future<bool> updateProduct(ProductHiveModel product) async {
    if (_productBox.containsKey(product.productId)) {
      await _productBox.put(product.productId, product);
      return true;
    }
    return false;
  }

  Future<void> deleteProduct(String productId) async {
    await _productBox.delete(productId);
  }

  Future<void> cacheAllProducts(List<ProductHiveModel> products) async {
    await _productBox.clear();
    for (var product in products) {
      await _productBox.put(product.productId, product);
    }
  }
}

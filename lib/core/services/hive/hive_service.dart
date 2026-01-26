import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/data/models/auth_hive_model.dart';
import 'package:hamro_deal/features/category/data/models/category_hive_model.dart';
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

    _registerAdapters();
    await _openBoxes();
  }

  // =================== Register Adapters ===================
  void _registerAdapters() {
    // Auth
    if (!Hive.isAdapterRegistered(HiveTableConstants.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // Product
    if (!Hive.isAdapterRegistered(HiveTableConstants.productTypeId)) {
      Hive.registerAdapter(ProductHiveModelAdapter());
    }

    // Category
    if (!Hive.isAdapterRegistered(HiveTableConstants.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
  }

  // =================== Open Boxes ===================
  Future<void> _openBoxes() async {
    // Auth box
    if (!Hive.isBoxOpen(HiveTableConstants.authTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstants.authTable);
    }

    // Product box
    if (!Hive.isBoxOpen(HiveTableConstants.productTable)) {
      await Hive.openBox<ProductHiveModel>(HiveTableConstants.productTable);
    }

    // Category box
    if (!Hive.isBoxOpen(HiveTableConstants.categoryTable)) {
      await Hive.openBox<CategoryHiveModel>(HiveTableConstants.categoryTable);
    }
  }

  // =================== Close ===================
  Future<void> close() async {
    await Hive.close();
  }

  // =================== Auth Queries ===================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.userId, model);
    return model;
  }

  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> logoutUser() async {}

  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // =================== Product Queries ===================
  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>(HiveTableConstants.productTable);

  Future<ProductHiveModel> createProduct(ProductHiveModel product) async {
    // product.productId MUST NOT be null
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

  List<ProductHiveModel> getProductsByCategory(String categoryId) {
    return _productBox.values
        .where((product) => product.category == categoryId)
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
    for (final product in products) {
      await _productBox.put(product.productId, product);
    }
  }

  // =================== Category Queries ===================
  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstants.categoryTable);

  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) async {
    // category.categoryId MUST NOT be null
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  List<CategoryHiveModel> getAllCategories() {
    return _categoryBox.values.toList();
  }

  CategoryHiveModel? getCategoryById(String categoryId) {
    return _categoryBox.get(categoryId);
  }

  Future<bool> updateCategory(CategoryHiveModel category) async {
    if (_categoryBox.containsKey(category.categoryId)) {
      await _categoryBox.put(category.categoryId, category);
      return true;
    }
    return false;
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }

  Future<void> cacheAllCategories(List<CategoryHiveModel> categories) async {
    await _categoryBox.clear();
    for (final category in categories) {
      await _categoryBox.put(category.categoryId, category);
    }
  }
}

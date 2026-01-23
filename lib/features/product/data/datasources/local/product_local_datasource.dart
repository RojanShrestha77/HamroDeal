import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/hive/hive_service.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';

// provider
final productLocalDatasourceProvider = Provider<ProductLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProductLocalDatasource(hiveService: hiveService);
});

class ProductLocalDatasource implements IProductLocalDataSource {
  final HiveService _hiveService;

  ProductLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createProduct(ProductHiveModel product) async {
    try {
      await _hiveService.createProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    try {
      await _hiveService.deleteProduct(productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductHiveModel>> getAllProducts() async {
    try {
      return _hiveService.getAllProducts();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductHiveModel?> getProductsById(String productId) async {
    try {
      return _hiveService.getProductById(productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductHiveModel>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      return _hiveService.getProductsByCategory(categoryId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProductHiveModel>> getProductsByUser(String userId) async {
    try {
      return _hiveService.getProductsByUser(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateProduct(ProductHiveModel product) async {
    try {
      return await _hiveService.updateProduct(product);
    } catch (e) {
      return false;
    }
  }

  // cache all items from the api response
  Future<void> cacheAllProducts(List<ProductHiveModel> products) async {
    await _hiveService.cacheAllProducts(products);
  }
}

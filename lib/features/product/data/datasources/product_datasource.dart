import 'dart:io';

import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';

abstract interface class IProductLocalDataSource {
  Future<List<ProductHiveModel>> getAllProducts();
  Future<List<ProductHiveModel>> getProductsByUser(String userId);
  Future<List<ProductHiveModel>> getProductsByCategory(String categoryId);
  Future<ProductHiveModel?> getProductsById(String productId);
  Future<bool> createProduct(ProductHiveModel product);
  Future<bool> updateProduct(ProductHiveModel product);
  Future<bool> deleteProduct(String productId);
  Future<List<ProductHiveModel>> getFilteredProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sort,
  });
}

abstract interface class IProductRemoteDataSource {
  Future<String> uploadImage(File image);
  Future<String> uploadVideo(File video);
  Future<ProductApiModel> createProduct(ProductApiModel product);
  Future<List<ProductApiModel>> getAllProducts();
  Future<List<ProductApiModel>> getProductsByUser(String userId);
  Future<List<ProductApiModel>> getProductsByCategory(String categoryId);
  Future<ProductApiModel> getProductById(String productId);
  Future<bool> updateProduct(ProductApiModel product);
  Future<bool> deleteProduct(String productId);
  Future<List<ProductApiModel>> getFilteredProducts({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  });
}

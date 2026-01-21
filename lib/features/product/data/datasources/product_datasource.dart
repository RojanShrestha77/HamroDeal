import 'dart:io';

import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';

abstract interface class IProductLocalDataSource {
  Future<List<ProductHiveModel>> getAllItems();
  Future<List<ProductHiveModel>> getItemsByUser(String userId);
  Future<List<ProductHiveModel>> getItemsByCategory(String categoryId);
  Future<ProductHiveModel?> getItemsById(String itemId);
  Future<bool> createItem(ProductHiveModel item);
  Future<bool> updateItem(ProductHiveModel item);
  Future<bool> deleteItem(String itemId);
}

abstract interface class IProductRemoteDataSource {
  Future<String> uploadImage(File image);
  Future<String> uploadVideo(File video);
}

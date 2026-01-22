import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';

// provider
final productLocalDatasourceProvider = Provider<IProductLocalDataSource>((ref) {
  return ProductLocalDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProductLocalDatasource implements IProductLocalDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  static const String _boxName = 'itemsBox';
  ProductLocalDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;
  @override
  Future<bool> createItem(ProductHiveModel item) {
    // TODO: implement createItem
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteItem(String itemId) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<List<ProductHiveModel>> getAllItems() {
    // TODO: implement getAllItems
    throw UnimplementedError();
  }

  @override
  Future<List<ProductHiveModel>> getItemsByCategory(String categoryId) {
    // TODO: implement getItemsByCategory
    throw UnimplementedError();
  }

  @override
  Future<ProductHiveModel?> getItemsById(String itemId) {
    // TODO: implement getItemsById
    throw UnimplementedError();
  }

  @override
  Future<List<ProductHiveModel>> getItemsByUser(String userId) {
    // TODO: implement getItemsByUser
    throw UnimplementedError();
  }

  @override
  Future<bool> updateItem(ProductHiveModel item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }
}

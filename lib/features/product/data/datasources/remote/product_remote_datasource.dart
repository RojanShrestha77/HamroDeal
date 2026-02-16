import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';

final productRemoteDatasourceProvider = Provider<IProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProductRemoteDatasource implements IProductRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProductRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;

    final formData = FormData.fromMap({
      'images': await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final token = _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.products,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    var imageUrl = response.data['data']['images'];
    return imageUrl;
  }

  @override
  Future<String> uploadVideo(File video) async {
    // Backend doesn't support video upload for products
    throw UnimplementedError('Video upload not supported by backend');
  }

  @override
  Future<ProductApiModel> createProduct(ProductApiModel product) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.products,
      data: product.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProductApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    final token = _tokenService.getToken();
    await _apiClient.delete(
      ApiEndpoints.productById(productId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }

  @override
  Future<List<ProductApiModel>> getAllProducts() async {
    final response = await _apiClient.get(ApiEndpoints.products);
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<ProductApiModel> getProductById(String productId) async {
    final response = await _apiClient.get(ApiEndpoints.productById(productId));
    return ProductApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ProductApiModel>> getProductsByCategory(String categoryId) async {
    final response = await _apiClient.get(
      ApiEndpoints.productsByCategory,
      queryParameters: {'categoryId': categoryId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductApiModel>> getProductsByUser(String userId) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.myProducts,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateProduct(ProductApiModel product) async {
    final token = _tokenService.getToken();
    await _apiClient.put(
      ApiEndpoints.productById(product.id!),
      data: product.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }
}

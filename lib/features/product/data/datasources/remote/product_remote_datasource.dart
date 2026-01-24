import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';

// provider
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
    // fromdata = used when need ot send the pohot images or video and other data together
    // fromdata.fromMap() = converts a dart map  into formdata sop it can be as a multipart form data to the backend

    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    // get token from the token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
    var a = response.data['data'];
    return a;
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    // fromdata = used when need ot send the pohot images or video and other data together
    // fromdata.fromMap() = converts a dart map  into formdata sop it can be as a multipart form data to the backend

    final formData = FormData.fromMap({
      'itemVideo': await MultipartFile.fromFile(video.path, filename: fileName),
    });
    // get token from the token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
    var a = response.data['success'];
    return a;
  }

  @override
  Future<ProductApiModel> createProduct(ProductApiModel product) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.items,
      data: product.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProductApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    final token = _tokenService.getToken();
    await _apiClient.delete(
      ApiEndpoints.itemById(productId),
      options: Options(headers: {'Authorization': 'Bearer$token'}),
    );
    return true;
  }

  @override
  Future<List<ProductApiModel>> getAllProducts() async {
    final response = await _apiClient.get(ApiEndpoints.items);
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<ProductApiModel> getProductById(String productId) async {
    final response = await _apiClient.get(ApiEndpoints.itemById(productId));
    return ProductApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ProductApiModel>> getProductsByCategory(String categoryId) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {'category': categoryId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductApiModel>> getProductsByUser(String userId) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {'id': userId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateProduct(ProductApiModel product) async {
    final token = _tokenService.getToken();
    await _apiClient.put(
      ApiEndpoints.itemById(product.id!),
      data: product.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }
}

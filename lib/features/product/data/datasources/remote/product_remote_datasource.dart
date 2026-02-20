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
    // Just return the file path - don't make any API calls
    return image.path;
  }

  @override
  Future<String> uploadVideo(File video) async {
    // Backend doesn't support video upload for products
    throw UnimplementedError('Video upload not supported by backend');
  }

  @override
  Future<ProductApiModel> createProduct(ProductApiModel product) async {
    final token = _tokenService.getToken();

    try {
      // Check if product has a local file path
      if (product.images != null && File(product.images!).existsSync()) {
        // Upload with FormData (includes image file)
        final formData = FormData.fromMap({
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'stock': product.stock.toString(),
          'categoryId': product.categoryId,
          'images': await MultipartFile.fromFile(
            product.images!,
            filename: product.images!.split('/').last,
          ),
        });

        print('🔵 Sending product data:');
        print('Title: ${product.title}');
        print('Description: ${product.description}');
        print('Price: ${product.price}');
        print('Stock: ${product.stock}');
        print('CategoryId: ${product.categoryId}');
        print('Image path: ${product.images}');

        final response = await _apiClient.post(
          ApiEndpoints.products,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );
        return ProductApiModel.fromJson(response.data['data']);
      } else {
        throw Exception('Product image is required');
      }
    } catch (e) {
      if (e is DioException) {
        print('🔴 DioException details:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        print('Request data: ${e.requestOptions.data}');
      }
      rethrow;
    }
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

    try {
      // Check if product has a new local file path (new image uploaded)
      if (product.images != null &&
          product.images!.isNotEmpty &&
          File(product.images!).existsSync()) {
        // Upload with FormData (includes new image file)
        final formData = FormData.fromMap({
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'stock': product.stock.toString(),
          'categoryId': product.categoryId,
          'images': await MultipartFile.fromFile(
            product.images!,
            filename: product.images!.split('/').last,
          ),
        });

        print('🟡 Updating product with new image:');
        print('Product ID: ${product.id}');
        print('Title: ${product.title}');
        print('Image path: ${product.images}');

        await _apiClient.put(
          ApiEndpoints.productById(product.id!),
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );
      } else {
        // No new image - send JSON data only
        print('🟡 Updating product without new image');
        await _apiClient.put(
          ApiEndpoints.productById(product.id!),
          data: product.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
      return true;
    } catch (e) {
      if (e is DioException) {
        print('🔴 Update Product DioException:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<ProductApiModel>> getFilteredProducts({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['categoryId'] = categoryId;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (minPrice != null) {
      queryParams['minPrice'] = minPrice.toString();
    }
    if (maxPrice != null) {
      queryParams['maxPrice'] = maxPrice.toString();
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await _apiClient.get(
      ApiEndpoints.products,
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List;
    return data.map((json) => ProductApiModel.fromJson(json)).toList();
  }
}

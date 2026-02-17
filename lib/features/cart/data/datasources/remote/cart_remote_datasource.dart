import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/cart/data/datasources/cart_datasource.dart';
import 'package:hamro_deal/features/cart/data/model/cart_api_model.dart';

final cartRemoteDatasourceProvider = Provider<ICartRemoteDataSource>((ref) {
  return CartRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class CartRemoteDatasource implements ICartRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  CartRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<CartApiModel> addToCart(String productId, int quantity) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.cart,
      data: {'productId': productId, 'quantity': quantity},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return CartApiModel.fromJson(response.data['data']);
  }

  @override
  Future<CartApiModel> getCart() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.cart,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return CartApiModel.fromJson(response.data['data']);
  }

  @override
  Future<CartApiModel> updateCartItem(String productId, int quantity) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.put(
      ApiEndpoints.updateCartItem(productId),
      data: {'quantity': quantity},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return CartApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> removeFromCart(String productId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.removeFromCart(productId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return true;
  }

  @override
  Future<bool> clearCart() async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.clearCart,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return true;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:hamro_deal/features/wishlist/data/model/wishlist_api_model.dart';

final wishlistRemoteDatasourceProvider = Provider<IWishlistRemoteDataSource>((
  ref,
) {
  return WishlistRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class WishlistRemoteDatasource implements IWishlistRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  WishlistRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<WishlistApiModel> addToWishlist(String productId) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.wishlist,
      data: {'productId': productId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return WishlistApiModel.fromJson(response.data['data']);
  }

  @override
  Future<WishlistApiModel> getWishlist() async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.wishlist,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return WishlistApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> removeFromWishlist(String productId) async {
    final token = await _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.removeFromWishlist(productId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return true;
  }

  @override
  Future<bool> clearWishlist() async {
    final token = await _tokenService.getToken();

    await _apiClient.delete(
      '${ApiEndpoints.wishlist}/clear/all',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return true;
  }
}

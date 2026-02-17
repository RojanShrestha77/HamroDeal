import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/order/data/datasource/order_datasource.dart';
import 'package:hamro_deal/features/order/data/models/order_api_model.dart';

final orderRemoteDatasourceProvider = Provider<IOrderRemoteDataSource>((ref) {
  return OrderRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class OrderRemoteDatasource implements IOrderRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  OrderRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<OrderApiModel> cancelOrder(String orderId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.cancelOrder(orderId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return OrderApiModel.fromJson(response.data['data']);
  }

  @override
  Future<OrderApiModel> createOrder(OrderApiModel order) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: order.toJson(),
      options: Options(headers: {'Authorization': '  Bearer $token'}),
    );
    return OrderApiModel.fromJson(response.data['data']);
  }

  @override
  Future<OrderApiModel> getOrderById(String orderId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.orderById(orderId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return OrderApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<OrderApiModel>> getUserOrders() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.myOrders,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((json) => OrderApiModel.fromJson(json)).toList();
  }
}

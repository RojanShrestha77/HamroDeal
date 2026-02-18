import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/admin/orders/data/datasource/admin_order_datasource.dart';
import 'package:hamro_deal/features/order/data/models/order_api_model.dart';

final adminOrderRemoteDatasourceProvider =
    Provider<IAdminOrderRemoteDataSource>((ref) {
      return AdminOrderRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class AdminOrderRemoteDatasource implements IAdminOrderRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AdminOrderRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<OrderApiModel>> getAllOrders() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminOrders,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data['data'] as List;
    return data.map((json) => OrderApiModel.fromJson(json)).toList();
  }

  @override
  Future<OrderApiModel> getOrderById(String orderId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminOrderById(orderId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return OrderApiModel.fromJson(response.data['data']);
  }

  @override
  Future<OrderApiModel> updateOrderStatus(String orderId, String status) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.adminUpdateOrderStatus(orderId),
      data: {'status': status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return OrderApiModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.adminDeleteOrder(orderId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

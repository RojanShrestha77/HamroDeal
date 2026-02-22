import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/admin/analytics/data/datasource/admin_analytics_datasource.dart';
import 'package:hamro_deal/features/admin/analytics/data/model/analytics_overview_model.dart';
import 'package:hamro_deal/features/admin/analytics/data/model/revenue_data_model.dart';
import 'package:hamro_deal/features/admin/analytics/data/model/top_product_model.dart';

final adminAnalyticsRemoteDatasourceProvider =
    Provider<IAdminAnalyticsDataSource>((ref) {
      return AdminAnalyticsRemoteDataSource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class AdminAnalyticsRemoteDataSource implements IAdminAnalyticsDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AdminAnalyticsRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<AnalyticsOverviewModel> getOverview() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminAnalyticsOverview,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AnalyticsOverviewModel.fromJson(response.data['data']);
  }

  @override
  Future<List<RevenueDataModel>> getRevenueData(
    String startDate,
    String endDate,
  ) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminAnalyticsRevenue,
      queryParameters: {'startDate': startDate, 'endDate': endDate},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => RevenueDataModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TopProductModel>> getTopProducts(int limit) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.adminAnalyticsTopProducts,
      queryParameters: {'limit': limit},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => TopProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

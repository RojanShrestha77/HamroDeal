import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/category/data/datasources/category_datasource.dart';
import 'package:hamro_deal/features/category/data/models/category_api_model.dart';

// provider
final categoryRemoteDatasourceProvider = Provider<CategoryRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return CategoryRemoteDatasource(apiClient: apiClient);
});

class CategoryRemoteDatasource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    final data = response.data['data'] as List;
    return data.map((json) => CategoryApiModel.fromJson(json)).toList();
  }
}

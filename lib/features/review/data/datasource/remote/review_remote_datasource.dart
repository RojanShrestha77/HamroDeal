import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/review/data/datasource/remote_datasource.dart';
import 'package:hamro_deal/features/review/data/models/review_model.dart';

// ADD PROVIDER
final reviewRemoteDataSourceProvider = Provider<IReviewDataSource>((ref) {
  return ReviewRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ReviewRemoteDataSource implements IReviewDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService; // ADD THIS

  ReviewRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService, // ADD THIS
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<ReviewModel>> getProductReviews(
    String productId,
    int page,
    int size,
  ) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.productReviews(productId)}?page=$page&size=$size',
    );
    // Use response.data['data'] not response['data']
    final data = response.data['data']['reviews'] as List;
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  @override
  Future<double> getAverageRating(String productId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.productReviews(productId)}?page=1&size=1',
    );
    return (response.data['data']['avgRating'] ?? 0.0).toDouble();
  }

  @override
  Future<int> getTotalReviews(String productId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.productReviews(productId)}?page=1&size=1',
    );
    return response.data['data']['pagination']['total'] ?? 0;
  }

  @override
  Future<ReviewModel> createReview(
    String productId,
    int rating,
    String comment,
  ) async {
    final token = _tokenService.getToken(); // GET TOKEN

    final response = await _apiClient.post(
      ApiEndpoints.createReview(productId),
      data: {'rating': rating, 'comment': comment},
      options: Options(
        headers: {'Authorization': 'Bearer $token'}, // ADD AUTH
      ),
    );
    return ReviewModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ReviewModel>> getUserReviews() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.myReviews,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  @override
  Future<ReviewModel> updateReview(
    String reviewId,
    int? rating,
    String? comment,
  ) async {
    final token = _tokenService.getToken();

    final Map<String, dynamic> data = {};
    if (rating != null) data['rating'] = rating;
    if (comment != null) data['comment'] = comment;

    final response = await _apiClient.patch(
      ApiEndpoints.updateReview(reviewId),
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ReviewModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.deleteReview(reviewId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

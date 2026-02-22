import 'package:hamro_deal/features/review/data/models/review_model.dart';

abstract class IReviewDataSource {
  Future<List<ReviewModel>> getProductReviews(
    String productId,
    int page,
    int size,
  );
  Future<double> getAverageRating(String productId);
  Future<int> getTotalReviews(String productId);
  Future<ReviewModel> createReview(
    String productId,
    int rating,
    String comment,
  );
  Future<List<ReviewModel>> getUserReviews();
  Future<ReviewModel> updateReview(
    String reviewId,
    int? rating,
    String? comment,
  );
  Future<void> deleteReview(String reviewId);
}

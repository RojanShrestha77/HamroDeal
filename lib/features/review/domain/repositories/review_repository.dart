import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';

abstract class IReviewRepository {
  Future<Either<ApiFailure, List<ReviewEntity>>> getProductReviews(
    String productId,
    int page,
    int size,
  );

  Future<Either<ApiFailure, double>> getAverageRating(String productId);

  Future<Either<ApiFailure, int>> getTotalReviews(String productId);

  Future<Either<ApiFailure, ReviewEntity>> createReview(
    String productId,
    int rating,
    String comment,
  );

  Future<Either<ApiFailure, List<ReviewEntity>>> getUserReviews();

  Future<Either<ApiFailure, ReviewEntity>> updateReview(
    String reviewId,
    int? rating,
    String? comment,
  );

  Future<Either<ApiFailure, void>> deleteReview(String reviewId);
}

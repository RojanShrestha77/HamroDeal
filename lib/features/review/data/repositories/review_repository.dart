import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/review/data/datasource/remote/review_remote_datasource.dart';
import 'package:hamro_deal/features/review/data/datasource/remote_datasource.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  final remoteDataSource = ref.read(reviewRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ReviewRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class ReviewRepositoryImpl implements IReviewRepository {
  final IReviewDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ReviewRepositoryImpl({
    required IReviewDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<ApiFailure, List<ReviewEntity>>> getProductReviews(
    String productId,
    int page,
    int size,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getProductReviews(
          productId,
          page,
          size,
        );
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, double>> getAverageRating(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        final avgRating = await _remoteDataSource.getAverageRating(productId);
        return Right(avgRating);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, int>> getTotalReviews(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        final total = await _remoteDataSource.getTotalReviews(productId);
        return Right(total);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, ReviewEntity>> createReview(
    String productId,
    int rating,
    String comment,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.createReview(
          productId,
          rating,
          comment,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, List<ReviewEntity>>> getUserReviews() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getUserReviews();
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, ReviewEntity>> updateReview(
    String reviewId,
    int? rating,
    String? comment,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.updateReview(
          reviewId,
          rating,
          comment,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> deleteReview(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteReview(reviewId);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}

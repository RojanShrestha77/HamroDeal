import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/review/data/repositories/review_repository.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

class GetProductReviewsParams extends Equatable {
  final String productId;
  final int page;
  final int size;

  const GetProductReviewsParams({
    required this.productId,
    required this.page,
    required this.size,
  });

  @override
  List<Object?> get props => [productId, page, size];
}

final getProductReviewsUsecaseProvider = Provider<GetProductReviewsUsecase>((
  ref,
) {
  final repository = ref.read(reviewRepositoryProvider);
  return GetProductReviewsUsecase(repository: repository);
});

class GetProductReviewsUsecase
    implements UsecaseWithParams<List<ReviewEntity>, GetProductReviewsParams> {
  final IReviewRepository _repository;

  GetProductReviewsUsecase({required IReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(
    GetProductReviewsParams params,
  ) {
    return _repository.getProductReviews(
      params.productId,
      params.page,
      params.size,
    );
  }
}

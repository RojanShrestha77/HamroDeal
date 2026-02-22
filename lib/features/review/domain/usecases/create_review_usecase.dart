import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/review/data/repositories/review_repository.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

class CreateReviewParams extends Equatable {
  final String productId;
  final int rating;
  final String comment;

  const CreateReviewParams({
    required this.productId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, rating, comment];
}

final createReviewUsecaseProvider = Provider<CreateReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);
  return CreateReviewUsecase(repository: repository);
});

class CreateReviewUsecase
    implements UsecaseWithParams<ReviewEntity, CreateReviewParams> {
  final IReviewRepository _repository;

  CreateReviewUsecase({required IReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) {
    return _repository.createReview(
      params.productId,
      params.rating,
      params.comment,
    );
  }
}

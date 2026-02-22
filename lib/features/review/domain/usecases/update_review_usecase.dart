import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/review/data/repositories/review_repository.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

class UpdateReviewParams extends Equatable {
  final String reviewId;
  final int? rating;
  final String? comment;

  const UpdateReviewParams({required this.reviewId, this.rating, this.comment});

  @override
  List<Object?> get props => [reviewId, rating, comment];
}

final updateReviewUsecaseProvider = Provider<UpdateReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);
  return UpdateReviewUsecase(repository: repository);
});

class UpdateReviewUsecase
    implements UsecaseWithParams<ReviewEntity, UpdateReviewParams> {
  final IReviewRepository _repository;

  UpdateReviewUsecase({required IReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ReviewEntity>> call(UpdateReviewParams params) {
    return _repository.updateReview(
      params.reviewId,
      params.rating,
      params.comment,
    );
  }
}

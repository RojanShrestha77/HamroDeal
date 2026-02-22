import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/review/data/repositories/review_repository.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

class DeleteReviewParams extends Equatable {
  final String reviewId;

  const DeleteReviewParams({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

final deleteReviewUsecaseProvider = Provider<DeleteReviewUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);
  return DeleteReviewUsecase(repository: repository);
});

class DeleteReviewUsecase
    implements UsecaseWithParams<void, DeleteReviewParams> {
  final IReviewRepository _repository;

  DeleteReviewUsecase({required IReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteReviewParams params) {
    return _repository.deleteReview(params.reviewId);
  }
}

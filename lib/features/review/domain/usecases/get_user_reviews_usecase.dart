import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/review/data/repositories/review_repository.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:hamro_deal/features/review/domain/repositories/review_repository.dart';

final getUserReviewsUsecaseProvider = Provider<GetUserReviewsUsecase>((ref) {
  final repository = ref.read(reviewRepositoryProvider);
  return GetUserReviewsUsecase(repository: repository);
});

class GetUserReviewsUsecase
    implements UsecaseWithoutParams<List<ReviewEntity>> {
  final IReviewRepository _repository;

  GetUserReviewsUsecase({required IReviewRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call() {
    return _repository.getUserReviews();
  }
}

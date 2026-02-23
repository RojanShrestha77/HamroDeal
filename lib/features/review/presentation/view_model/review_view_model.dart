import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/review/domain/usecases/create_review_usecase.dart';
import 'package:hamro_deal/features/review/domain/usecases/delete_review_usecase.dart';
import 'package:hamro_deal/features/review/domain/usecases/get_product_reviews_usecase.dart';
import 'package:hamro_deal/features/review/domain/usecases/get_user_reviews_usecase.dart';
import 'package:hamro_deal/features/review/domain/usecases/update_review_usecase.dart';
import 'package:hamro_deal/features/review/presentation/state/review_state.dart';

final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(
  () => ReviewViewModel(),
);

class ReviewViewModel extends Notifier<ReviewState> {
  late final GetProductReviewsUsecase _getProductReviewsUsecase;
  late final CreateReviewUsecase _createReviewUsecase;
  late final UpdateReviewUsecase _updateReviewUsecase;
  late final DeleteReviewUsecase _deleteReviewUsecase;
  late final GetUserReviewsUsecase _getUserReviewsUsecase;

  @override
  ReviewState build() {
    _getProductReviewsUsecase = ref.read(getProductReviewsUsecaseProvider);
    _createReviewUsecase = ref.read(createReviewUsecaseProvider);
    _updateReviewUsecase = ref.read(updateReviewUsecaseProvider);
    _deleteReviewUsecase = ref.read(deleteReviewUsecaseProvider);
    _getUserReviewsUsecase = ref.read(getUserReviewsUsecaseProvider);

    return ReviewState.initial();
  }

  Future<void> loadReviews(
    String productId, {
    int page = 1,
    int size = 10,
  }) async {
    state = state.copyWith(status: ReviewStatus.loading);

    final params = GetProductReviewsParams(
      productId: productId,
      page: page,
      size: size,
    );

    final result = await _getProductReviewsUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ReviewStatus.error,
          error: failure.message,
        );
      },
      (reviews) {
        state = state.copyWith(
          status: ReviewStatus.success,
          reviews: reviews,
          clearError: true,
        );
      },
    );
  }

  Future<bool> createReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      submitSuccess: false,
      clearSubmitError: true,
    );

    final params = CreateReviewParams(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    final result = await _createReviewUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: failure.message,
          submitSuccess: false,
        );
        return false;
      },
      (review) {
        state = state.copyWith(
          isSubmitting: false,
          submitSuccess: true,
          clearSubmitError: true,
        );
        // Reload reviews after creating
        loadReviews(productId);
        return true;
      },
    );
  }

  Future<bool> updateReview({
    required String reviewId,
    required String productId,
    int? rating,
    String? comment,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      submitSuccess: false,
      clearSubmitError: true,
    );

    final params = UpdateReviewParams(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
    );

    final result = await _updateReviewUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: failure.message,
          submitSuccess: false,
        );
        return false;
      },
      (review) {
        state = state.copyWith(
          isSubmitting: false,
          submitSuccess: true,
          clearSubmitError: true,
        );
        // Reload reviews after updating
        loadReviews(productId);
        return true;
      },
    );
  }

  Future<bool> deleteReview({
    required String reviewId,
    required String productId,
  }) async {
    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    final params = DeleteReviewParams(reviewId: reviewId);

    final result = await _deleteReviewUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isSubmitting: false, clearSubmitError: true);
        // Reload reviews after deleting
        loadReviews(productId);
        return true;
      },
    );
  }

  Future<void> loadUserReviews() async {
    state = state.copyWith(status: ReviewStatus.loading);

    final result = await _getUserReviewsUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ReviewStatus.error,
          error: failure.message,
        );
      },
      (reviews) {
        state = state.copyWith(
          status: ReviewStatus.success,
          reviews: reviews,
          clearError: true,
        );
      },
    );
  }

  Future<void> refresh(String productId) async {
    await loadReviews(productId);
  }

  void resetSubmitState() {
    state = state.copyWith(submitSuccess: false, clearSubmitError: true);
  }
}

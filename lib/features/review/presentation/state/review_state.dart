import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';

enum ReviewStatus { intital, loading, success, error }

class ReviewState extends Equatable {
  final ReviewStatus status;
  final List<ReviewEntity> reviews;
  final double averageRating;
  final int totalReviews;
  final String? error;
  final bool isSubmitting;
  final String? submitError;
  final bool submitSuccess;

  const ReviewState({
    required this.status,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    this.error,
    required this.isSubmitting,
    this.submitError,
    required this.submitSuccess,
  });

  factory ReviewState.initial() {
    return const ReviewState(
      status: ReviewStatus.intital,
      reviews: [],
      averageRating: 0.0,
      totalReviews: 0,
      isSubmitting: false,
      submitSuccess: false,
    );
  }

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewEntity>? reviews,
    double? averageRating,
    int? totalReviews,
    String? error,
    bool? isSubmitting,
    String? submitError,
    bool? submitSuccess,
    bool clearError = false,
    bool clearSubmitError = false,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      error: clearError ? null : (error ?? this.error),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviews,
    averageRating,
    totalReviews,
    error,
    isSubmitting,
    submitError,
    submitSuccess,
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hamro_deal/features/review/presentation/state/review_state.dart';
import 'package:hamro_deal/features/review/presentation/view_model/review_view_model.dart';
import 'package:hamro_deal/features/review/presentation/widgets/add_review_dialog.dart';
import 'package:hamro_deal/features/review/presentation/widgets/review_card.dart';

class ProductReviewsSection extends ConsumerStatefulWidget {
  final String productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  ConsumerState<ProductReviewsSection> createState() =>
      _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends ConsumerState<ProductReviewsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewViewModelProvider.notifier).loadReviews(widget.productId);
    });
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        onSubmit: (rating, comment) async {
          final success = await ref
              .read(reviewViewModelProvider.notifier)
              .createReview(
                productId: widget.productId,
                rating: rating,
                comment: comment,
              );

          if (success && mounted) {
            SnackbarUtils.showSuccess(context, 'Review added successfully');
          } else if (mounted) {
            final error = ref.read(reviewViewModelProvider).submitError;
            SnackbarUtils.showError(context, error ?? 'Failed to add review');
          }
        },
      ),
    );
  }

  void _showEditReviewDialog(String reviewId, int rating, String comment) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        initalRating: rating,
        initialComment: comment,
        onSubmit: (newRating, newComment) async {
          final success = await ref
              .read(reviewViewModelProvider.notifier)
              .updateReview(
                reviewId: reviewId,
                productId: widget.productId,
                rating: newRating,
                comment: newComment,
              );

          if (success && mounted) {
            SnackbarUtils.showSuccess(context, 'Review updated successfully');
          } else if (mounted) {
            final error = ref.read(reviewViewModelProvider).submitError;
            SnackbarUtils.showError(
              context,
              error ?? 'Failed to update review',
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(reviewViewModelProvider.notifier)
                  .deleteReview(
                    reviewId: reviewId,
                    productId: widget.productId,
                  );
              if (success && mounted) {
                SnackbarUtils.showSuccess(
                  context,
                  'Review deleted successfully',
                );
              } else if (mounted) {
                final error = ref.read(reviewViewModelProvider).submitError;
                SnackbarUtils.showError(
                  context,
                  error ?? 'Failed to delete review',
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewViewModelProvider);
    final authState = ref.watch(authViewModelProvider);
    final currentUserId = authState.authEntity?.userId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (currentUserId != null)
                ElevatedButton.icon(
                  onPressed: _showAddReviewDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Review'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (reviewState.status == ReviewStatus.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (reviewState.status == ReviewStatus.error)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                reviewState.error ?? 'Failed to load reviews',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        else if (reviewState.reviews.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No reviews yet. Be the first to review!'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reviewState.reviews.length,
            itemBuilder: (context, index) {
              final review = reviewState.reviews[index];
              final isOwnReview = review.user.id == currentUserId;

              return ReviewCard(
                review: review,
                canEdit: isOwnReview,
                onEdit: () => _showEditReviewDialog(
                  review.id,
                  review.rating,
                  review.comment,
                ),
                onDelete: () => _showDeleteConfirmation(review.id),
              );
            },
          ),
      ],
    );
  }
}

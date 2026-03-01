import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Delete Review',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          GestureDetector(
            onTap: () async {
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
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
        // ── Section header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (reviewState.reviews.isNotEmpty)
                    Text(
                      '${reviewState.reviews.length} review${reviewState.reviews.length == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
              if (currentUserId != null)
                GestureDetector(
                  onTap: _showAddReviewDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Write a Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ── Average rating bar (if reviews exist) ──
        if (reviewState.reviews.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // Big average number
                  Text(
                    _getAverageRating(
                      reviewState.reviews.map((r) => r.rating).toList(),
                    ),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          final avg =
                              double.tryParse(
                                _getAverageRating(
                                  reviewState.reviews
                                      .map((r) => r.rating)
                                      .toList(),
                                ),
                              ) ??
                              0;
                          return Icon(
                            i < avg.floor()
                                ? Icons.star
                                : i < avg
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.black,
                            size: 18,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reviewState.reviews.length} review${reviewState.reviews.length == 1 ? '' : 's'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── States ──
        if (reviewState.status == ReviewStatus.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          )
        else if (reviewState.status == ReviewStatus.error)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                reviewState.error ?? 'Failed to load reviews',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else if (reviewState.reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_border,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Be the first to review this product',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reviewState.reviews.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Color(0xFFEEEEEE), height: 1),
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

  String _getAverageRating(List<int> ratings) {
    if (ratings.isEmpty) return '0.0';
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;
    return avg.toStringAsFixed(1);
  }
}

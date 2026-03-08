import 'package:flutter/material.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.canEdit = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: review.user.profileImage != null
                      ? NetworkImage(ApiEndpoints.userProfileImage(review.user.profileImage!))
                      : null,
                  child: review.user.profileImage == null
                      ? Text(
                          review.user.firstName != null && review.user.firstName!.isNotEmpty
                              ? review.user.firstName![0].toUpperCase()
                              : 'U',
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.user.fullName ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(review.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Star rating
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                // Edit/Delete buttons
                if (canEdit) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Comment
            Text(review.comment ?? '', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

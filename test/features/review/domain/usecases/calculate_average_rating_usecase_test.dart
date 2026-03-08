import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity - Rating Calculation', () {
    test('calculates average rating for single review', () {
      final user = ReviewUserEntity(
        id: 'user1',
        firstName: 'John',
        lastName: 'Doe',
      );
      final reviews = [
        ReviewEntity(
          id: '1',
          productId: 'prod1',
          user: user,
          rating: 5,
          comment: 'Great product',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      final average = reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
      expect(average, 5);
    });

    test('calculates average rating for multiple reviews', () {
      final user = ReviewUserEntity(
        id: 'user1',
        firstName: 'John',
        lastName: 'Doe',
      );
      final now = DateTime.now();
      final reviews = [
        ReviewEntity(id: '1', productId: 'prod1', user: user, rating: 5, comment: 'Great', createdAt: now, updatedAt: now),
        ReviewEntity(id: '2', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '3', productId: 'prod1', user: user, rating: 3, comment: 'OK', createdAt: now, updatedAt: now),
        ReviewEntity(id: '4', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '5', productId: 'prod1', user: user, rating: 5, comment: 'Excellent', createdAt: now, updatedAt: now),
      ];
      final average = reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
      expect(average, closeTo(4.2, 0.01));
    });

    test('returns 0 for empty reviews', () {
      final reviews = <ReviewEntity>[];
      final average = reviews.isEmpty ? 0.0 : reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
      expect(average, 0);
    });

    test('calculates average for all same ratings', () {
      final user = ReviewUserEntity(id: 'user1', firstName: 'John', lastName: 'Doe');
      final now = DateTime.now();
      final reviews = [
        ReviewEntity(id: '1', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '2', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '3', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '4', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
      ];
      final average = reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
      expect(average, 4);
    });

    test('calculates average for mixed ratings', () {
      final user = ReviewUserEntity(id: 'user1', firstName: 'John', lastName: 'Doe');
      final now = DateTime.now();
      final reviews = [
        ReviewEntity(id: '1', productId: 'prod1', user: user, rating: 1, comment: 'Bad', createdAt: now, updatedAt: now),
        ReviewEntity(id: '2', productId: 'prod1', user: user, rating: 2, comment: 'Poor', createdAt: now, updatedAt: now),
        ReviewEntity(id: '3', productId: 'prod1', user: user, rating: 3, comment: 'OK', createdAt: now, updatedAt: now),
        ReviewEntity(id: '4', productId: 'prod1', user: user, rating: 4, comment: 'Good', createdAt: now, updatedAt: now),
        ReviewEntity(id: '5', productId: 'prod1', user: user, rating: 5, comment: 'Great', createdAt: now, updatedAt: now),
      ];
      final average = reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;
      expect(average, 3);
    });
  });
}

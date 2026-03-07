import 'package:flutter_test/flutter_test.dart';

class SellerRating {
  final int rating;
  final int count;

  SellerRating({required this.rating, required this.count});
}

class CalculateSellerRatingUseCase {
  double call(List<SellerRating> ratings) {
    if (ratings.isEmpty) return 0;
    final totalRating = ratings.fold(0, (sum, r) => sum + (r.rating * r.count));
    final totalCount = ratings.fold(0, (sum, r) => sum + r.count);
    return totalCount == 0 ? 0 : totalRating / totalCount;
  }
}

void main() {
  group('CalculateSellerRatingUseCase', () {
    late CalculateSellerRatingUseCase useCase;

    setUp(() {
      useCase = CalculateSellerRatingUseCase();
    });

    test('calculates average seller rating', () {
      final ratings = [
        SellerRating(rating: 5, count: 10),
        SellerRating(rating: 4, count: 5),
      ];
      expect(useCase(ratings), closeTo(4.67, 0.01));
    });

    test('returns 0 for empty ratings', () {
      expect(useCase([]), 0);
    });

    test('calculates for single rating', () {
      final ratings = [SellerRating(rating: 4, count: 1)];
      expect(useCase(ratings), 4);
    });

    test('handles multiple ratings correctly', () {
      final ratings = [
        SellerRating(rating: 5, count: 20),
        SellerRating(rating: 3, count: 10),
      ];
      expect(useCase(ratings), closeTo(4.33, 0.01));
    });

    test('calculates with zero count', () {
      final ratings = [SellerRating(rating: 5, count: 0)];
      expect(useCase(ratings), 0);
    });
  });
}

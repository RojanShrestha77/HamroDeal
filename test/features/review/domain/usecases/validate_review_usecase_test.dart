import 'package:flutter_test/flutter_test.dart';

class ValidateReviewUseCase {
  bool call(String reviewText, int rating) {
    return reviewText.isNotEmpty &&
        reviewText.length >= 10 &&
        rating >= 1 &&
        rating <= 5;
  }
}

void main() {
  group('ValidateReviewUseCase', () {
    late ValidateReviewUseCase useCase;

    setUp(() {
      useCase = ValidateReviewUseCase();
    });

    test('returns true for valid review', () {
      expect(useCase('This is a great product!', 5), true);
    });

    test('returns false for empty review', () {
      expect(useCase('', 5), false);
    });

    test('returns false for review less than 10 characters', () {
      expect(useCase('Good', 5), false);
    });

    test('returns false for invalid rating below 1', () {
      expect(useCase('This is a great product!', 0), false);
    });

    test('returns false for invalid rating above 5', () {
      expect(useCase('This is a great product!', 6), false);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

class CalculateAverageRatingUseCase {
  double call(List<int> ratings) {
    if (ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }
}

void main() {
  group('CalculateAverageRatingUseCase', () {
    late CalculateAverageRatingUseCase useCase;

    setUp(() {
      useCase = CalculateAverageRatingUseCase();
    });

    test('calculates average for single rating', () {
      expect(useCase([5]), 5);
    });

    test('calculates average for multiple ratings', () {
      expect(useCase([5, 4, 3, 4, 5]), closeTo(4.2, 0.01));
    });

    test('returns 0 for empty ratings', () {
      expect(useCase([]), 0);
    });

    test('calculates average for all same ratings', () {
      expect(useCase([4, 4, 4, 4]), 4);
    });

    test('calculates average for mixed ratings', () {
      expect(useCase([1, 2, 3, 4, 5]), 3);
    });
  });
}

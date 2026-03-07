import 'package:flutter_test/flutter_test.dart';

class ApplyDiscountUseCase {
  double call(double total, double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) return total;
    return total * (1 - (discountPercent / 100));
  }
}

void main() {
  group('ApplyDiscountUseCase', () {
    late ApplyDiscountUseCase useCase;

    setUp(() {
      useCase = ApplyDiscountUseCase();
    });

    test('applies 10% discount correctly', () {
      expect(useCase(100, 10), closeTo(90, 0.01));
    });

    test('applies 50% discount correctly', () {
      expect(useCase(100, 50), closeTo(50, 0.01));
    });

    test('returns original total for 0% discount', () {
      expect(useCase(100, 0), 100);
    });

    test('returns 0 for 100% discount', () {
      expect(useCase(100, 100), 0);
    });

    test('returns original total for invalid discount', () {
      expect(useCase(100, 150), 100);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

class ValidateOrderUseCase {
  bool call({
    required List<String> items,
    required String address,
    required String paymentMethod,
  }) {
    return items.isNotEmpty &&
        address.isNotEmpty &&
        address.length >= 10 &&
        paymentMethod.isNotEmpty;
  }
}

void main() {
  group('ValidateOrderUseCase', () {
    late ValidateOrderUseCase useCase;

    setUp(() {
      useCase = ValidateOrderUseCase();
    });

    test('returns true for valid order', () {
      expect(
        useCase(
          items: ['item1', 'item2'],
          address: '123 Main Street, City',
          paymentMethod: 'credit_card',
        ),
        true,
      );
    });

    test('returns false for empty items', () {
      expect(
        useCase(
          items: [],
          address: '123 Main Street, City',
          paymentMethod: 'credit_card',
        ),
        false,
      );
    });

    test('returns false for empty address', () {
      expect(
        useCase(
          items: ['item1'],
          address: '',
          paymentMethod: 'credit_card',
        ),
        false,
      );
    });

    test('returns false for short address', () {
      expect(
        useCase(
          items: ['item1'],
          address: '123 Main',
          paymentMethod: 'credit_card',
        ),
        false,
      );
    });

    test('returns false for empty payment method', () {
      expect(
        useCase(
          items: ['item1'],
          address: '123 Main Street, City',
          paymentMethod: '',
        ),
        false,
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

class CartItem {
  final String id;
  final double price;
  final int quantity;

  CartItem({required this.id, required this.price, required this.quantity});
}

class CalculateCartTotalUseCase {
  double call(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}

void main() {
  group('CalculateCartTotalUseCase', () {
    late CalculateCartTotalUseCase useCase;

    setUp(() {
      useCase = CalculateCartTotalUseCase();
    });

    test('returns 0 for empty cart', () {
      expect(useCase([]), 0);
    });

    test('calculates total for single item', () {
      final items = [CartItem(id: '1', price: 100, quantity: 1)];
      expect(useCase(items), 100);
    });

    test('calculates total for multiple items', () {
      final items = [
        CartItem(id: '1', price: 100, quantity: 2),
        CartItem(id: '2', price: 50, quantity: 1),
      ];
      expect(useCase(items), 250);
    });

    test('calculates total with decimal prices', () {
      final items = [CartItem(id: '1', price: 99.99, quantity: 2)];
      expect(useCase(items), closeTo(199.98, 0.01));
    });

    test('calculates total for large quantities', () {
      final items = [CartItem(id: '1', price: 10, quantity: 100)];
      expect(useCase(items), 1000);
    });
  });
}

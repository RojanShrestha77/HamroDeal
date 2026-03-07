import 'package:flutter_test/flutter_test.dart';

class OrderItem {
  final String id;
  final double price;
  final int quantity;

  OrderItem({required this.id, required this.price, required this.quantity});
}

class CalculateOrderTotalUseCase {
  double call(List<OrderItem> items, {double shippingCost = 0, double taxRate = 0.1}) {
    final subtotal = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final tax = subtotal * taxRate;
    return subtotal + tax + shippingCost;
  }
}

void main() {
  group('CalculateOrderTotalUseCase', () {
    late CalculateOrderTotalUseCase useCase;

    setUp(() {
      useCase = CalculateOrderTotalUseCase();
    });

    test('calculates total with tax', () {
      final items = [OrderItem(id: '1', price: 100, quantity: 1)];
      expect(useCase(items), closeTo(110, 0.01));
    });

    test('calculates total with shipping', () {
      final items = [OrderItem(id: '1', price: 100, quantity: 1)];
      expect(useCase(items, shippingCost: 10), closeTo(120, 0.01));
    });

    test('calculates total with tax and shipping', () {
      final items = [OrderItem(id: '1', price: 100, quantity: 1)];
      expect(useCase(items, shippingCost: 10, taxRate: 0.1), closeTo(120, 0.01));
    });

    test('calculates total for multiple items', () {
      final items = [
        OrderItem(id: '1', price: 100, quantity: 1),
        OrderItem(id: '2', price: 50, quantity: 2),
      ];
      expect(useCase(items), closeTo(220, 0.01));
    });

    test('calculates total with zero tax rate', () {
      final items = [OrderItem(id: '1', price: 100, quantity: 1)];
      expect(useCase(items, taxRate: 0), 100);
    });
  });
}

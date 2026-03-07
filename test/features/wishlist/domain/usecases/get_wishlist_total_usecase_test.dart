import 'package:flutter_test/flutter_test.dart';

class WishlistProduct {
  final String id;
  final double price;

  WishlistProduct({required this.id, required this.price});
}

class GetWishlistTotalUseCase {
  double call(List<WishlistProduct> items) {
    return items.fold(0, (sum, item) => sum + item.price);
  }
}

void main() {
  group('GetWishlistTotalUseCase', () {
    late GetWishlistTotalUseCase useCase;

    setUp(() {
      useCase = GetWishlistTotalUseCase();
    });

    test('returns 0 for empty wishlist', () {
      expect(useCase([]), 0);
    });

    test('calculates total for single item', () {
      final items = [WishlistProduct(id: '1', price: 99.99)];
      expect(useCase(items), closeTo(99.99, 0.01));
    });

    test('calculates total for multiple items', () {
      final items = [
        WishlistProduct(id: '1', price: 100),
        WishlistProduct(id: '2', price: 50),
      ];
      expect(useCase(items), 150);
    });

    test('calculates total with decimal prices', () {
      final items = [
        WishlistProduct(id: '1', price: 99.99),
        WishlistProduct(id: '2', price: 49.99),
      ];
      expect(useCase(items), closeTo(149.98, 0.01));
    });

    test('calculates total for large wishlist', () {
      final items = List.generate(10, (i) => WishlistProduct(id: '$i', price: 10));
      expect(useCase(items), 100);
    });
  });
}

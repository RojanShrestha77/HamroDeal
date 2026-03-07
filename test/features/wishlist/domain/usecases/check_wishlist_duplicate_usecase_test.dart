import 'package:flutter_test/flutter_test.dart';

class WishlistItem {
  final String productId;
  final String productName;

  WishlistItem({required this.productId, required this.productName});
}

class CheckWishlistDuplicateUseCase {
  bool call(List<WishlistItem> items, String productId) {
    return items.any((item) => item.productId == productId);
  }
}

void main() {
  group('CheckWishlistDuplicateUseCase', () {
    late CheckWishlistDuplicateUseCase useCase;
    late List<WishlistItem> wishlist;

    setUp(() {
      useCase = CheckWishlistDuplicateUseCase();
      wishlist = [
        WishlistItem(productId: '1', productName: 'Product 1'),
        WishlistItem(productId: '2', productName: 'Product 2'),
      ];
    });

    test('returns true if product exists in wishlist', () {
      expect(useCase(wishlist, '1'), true);
    });

    test('returns false if product does not exist in wishlist', () {
      expect(useCase(wishlist, '3'), false);
    });

    test('returns false for empty wishlist', () {
      expect(useCase([], '1'), false);
    });

    test('returns true for multiple items in wishlist', () {
      expect(useCase(wishlist, '2'), true);
    });

    test('returns false for non-existent product in non-empty wishlist', () {
      expect(useCase(wishlist, '999'), false);
    });
  });
}

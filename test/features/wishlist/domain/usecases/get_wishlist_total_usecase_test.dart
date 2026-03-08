import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_item_entity.dart';

void main() {
  group('WishlistEntity - Total Calculation', () {
    test('returns 0 for empty wishlist', () {
      final wishlist = WishlistEntity(items: []);
      expect(wishlist.isEmpty, true);
      expect(wishlist.itemCount, 0);
    });

    test('calculates item count for single item', () {
      final items = [
        WishlistItemEntity(
          productId: 'prod1',
          addedAt: DateTime.now(),
        ),
      ];
      final wishlist = WishlistEntity(items: items);
      expect(wishlist.itemCount, 1);
    });

    test('calculates item count for multiple items', () {
      final items = [
        WishlistItemEntity(productId: 'prod1', addedAt: DateTime.now()),
        WishlistItemEntity(productId: 'prod2', addedAt: DateTime.now()),
      ];
      final wishlist = WishlistEntity(items: items);
      expect(wishlist.itemCount, 2);
    });

    test('wishlist isEmpty returns false when has items', () {
      final items = [
        WishlistItemEntity(productId: 'prod1', addedAt: DateTime.now()),
      ];
      final wishlist = WishlistEntity(items: items);
      expect(wishlist.isEmpty, false);
    });

    test('calculates item count for large wishlist', () {
      final items = List.generate(
        10,
        (i) => WishlistItemEntity(
          productId: 'prod$i',
          addedAt: DateTime.now(),
        ),
      );
      final wishlist = WishlistEntity(items: items);
      expect(wishlist.itemCount, 10);
    });

    test('WishlistEntity are equatable', () {
      final items = [
        WishlistItemEntity(productId: 'prod1', addedAt: DateTime.now()),
      ];
      final wishlist1 = WishlistEntity(items: items);
      final wishlist2 = WishlistEntity(items: items);
      expect(wishlist1, equals(wishlist2));
    });
  });
}

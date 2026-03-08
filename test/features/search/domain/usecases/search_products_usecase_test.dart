import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity - Search', () {
    late List<ProductEntity> products;

    setUp(() {
      products = [
        ProductEntity(
          productId: '1',
          title: 'Laptop',
          description: 'High performance computer',
          price: 1000,
          stock: 5,
        ),
        ProductEntity(
          productId: '2',
          title: 'Mouse',
          description: 'Wireless mouse',
          price: 50,
          stock: 20,
        ),
        ProductEntity(
          productId: '3',
          title: 'Keyboard',
          description: 'Mechanical keyboard',
          price: 150,
          stock: 10,
        ),
      ];
    });

    test('searches products by title', () {
      final results = products
          .where((p) => p.title.toLowerCase().contains('laptop'))
          .toList();
      expect(results.length, 1);
      expect(results[0].title, 'Laptop');
    });

    test('searches products by description', () {
      final results = products
          .where((p) => p.description.toLowerCase().contains('wireless'))
          .toList();
      expect(results.length, 1);
      expect(results[0].title, 'Mouse');
    });

    test('returns empty list for no matches', () {
      final results = products
          .where((p) =>
              p.title.toLowerCase().contains('monitor') ||
              p.description.toLowerCase().contains('monitor'))
          .toList();
      expect(results.length, 0);
    });

    test('case-insensitive search', () {
      final results = products
          .where((p) => p.title.toLowerCase().contains('LAPTOP'.toLowerCase()))
          .toList();
      expect(results.length, 1);
    });

    test('searches multiple products', () {
      final results = products
          .where((p) =>
              p.description.toLowerCase().contains('computer') ||
              p.description.toLowerCase().contains('keyboard'))
          .toList();
      expect(results.length, 2);
    });
  });
}

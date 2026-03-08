import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity - Sorting', () {
    late List<ProductEntity> products;

    setUp(() {
      products = [
        ProductEntity(
          productId: '1',
          title: 'Laptop',
          description: 'High-end laptop',
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

    test('ProductEntity can be sorted by price ascending', () {
      final sorted = [...products]..sort((a, b) => a.price.compareTo(b.price));
      expect(sorted[0].price, 50);
      expect(sorted[1].price, 150);
      expect(sorted[2].price, 1000);
    });

    test('ProductEntity can be sorted by price descending', () {
      final sorted = [...products]..sort((a, b) => b.price.compareTo(a.price));
      expect(sorted[0].price, 1000);
      expect(sorted[1].price, 150);
      expect(sorted[2].price, 50);
    });

    test('ProductEntity can be sorted by title', () {
      final sorted = [...products]..sort((a, b) => a.title.compareTo(b.title));
      expect(sorted[0].title, 'Keyboard');
      expect(sorted[1].title, 'Laptop');
      expect(sorted[2].title, 'Mouse');
    });

    test('ProductEntity can be sorted by stock', () {
      final sorted = [...products]..sort((a, b) => b.stock.compareTo(a.stock));
      expect(sorted[0].stock, 20);
      expect(sorted[1].stock, 10);
      expect(sorted[2].stock, 5);
    });

    test('ProductEntity firstImage returns first image or null', () {
      final productWithImages = ProductEntity(
        productId: '1',
        title: 'Product',
        description: 'Description',
        price: 100,
        stock: 5,
        images: ['image1.jpg', 'image2.jpg'],
      );

      expect(productWithImages.firstImage, 'image1.jpg');
    });

    test('ProductEntity firstImage returns null when no images', () {
      final productNoImages = ProductEntity(
        productId: '1',
        title: 'Product',
        description: 'Description',
        price: 100,
        stock: 5,
      );

      expect(productNoImages.firstImage, null);
    });

    test('ProductEntity are equatable', () {
      final product1 = ProductEntity(
        productId: '1',
        title: 'Laptop',
        description: 'High-end laptop',
        price: 1000,
        stock: 5,
      );

      final product2 = ProductEntity(
        productId: '1',
        title: 'Laptop',
        description: 'High-end laptop',
        price: 1000,
        stock: 5,
      );

      expect(product1, equals(product2));
    });
  });
}

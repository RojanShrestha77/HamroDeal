import 'package:flutter_test/flutter_test.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.stock,
  });
}

class FilterProductsUseCase {
  List<Product> call(
    List<Product> products, {
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) {
    return products.where((product) {
      if (minPrice != null && product.price < minPrice) return false;
      if (maxPrice != null && product.price > maxPrice) return false;
      if (minRating != null && product.rating < minRating) return false;
      return true;
    }).toList();
  }
}

void main() {
  group('FilterProductsUseCase', () {
    late FilterProductsUseCase useCase;
    late List<Product> products;

    setUp(() {
      useCase = FilterProductsUseCase();
      products = [
        Product(id: '1', name: 'Product 1', price: 50, rating: 4.5, stock: 10),
        Product(id: '2', name: 'Product 2', price: 100, rating: 3.5, stock: 5),
        Product(id: '3', name: 'Product 3', price: 150, rating: 4.8, stock: 20),
      ];
    });

    test('returns all products when no filter applied', () {
      expect(useCase(products).length, 3);
    });

    test('filters by minimum price', () {
      final filtered = useCase(products, minPrice: 100);
      expect(filtered.length, 2);
    });

    test('filters by maximum price', () {
      final filtered = useCase(products, maxPrice: 100);
      expect(filtered.length, 2);
    });

    test('filters by minimum rating', () {
      final filtered = useCase(products, minRating: 4.5);
      expect(filtered.length, 2);
    });

    test('filters by multiple criteria', () {
      final filtered = useCase(products, minPrice: 50, maxPrice: 150, minRating: 4.0);
      expect(filtered.length, 2);
    });
  });
}

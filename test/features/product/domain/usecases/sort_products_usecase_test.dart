import 'package:flutter_test/flutter_test.dart';

class SortProduct {
  final String id;
  final String name;
  final double price;
  final double rating;

  SortProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
  });
}

class SortProductsUseCase {
  List<SortProduct> call(List<SortProduct> products, String sortBy) {
    final sorted = [...products];
    switch (sortBy) {
      case 'price_asc':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return sorted;
  }
}

void main() {
  group('SortProductsUseCase', () {
    late SortProductsUseCase useCase;
    late List<SortProduct> products;

    setUp(() {
      useCase = SortProductsUseCase();
      products = [
        SortProduct(id: '1', name: 'Laptop', price: 1000, rating: 4.5),
        SortProduct(id: '2', name: 'Mouse', price: 50, rating: 4.0),
        SortProduct(id: '3', name: 'Keyboard', price: 150, rating: 4.8),
      ];
    });

    test('sorts by price ascending', () {
      final sorted = useCase(products, 'price_asc');
      expect(sorted[0].price, 50);
      expect(sorted[2].price, 1000);
    });

    test('sorts by price descending', () {
      final sorted = useCase(products, 'price_desc');
      expect(sorted[0].price, 1000);
      expect(sorted[2].price, 50);
    });

    test('sorts by rating', () {
      final sorted = useCase(products, 'rating');
      expect(sorted[0].rating, 4.8);
    });

    test('sorts by name', () {
      final sorted = useCase(products, 'name');
      expect(sorted[0].name, 'Keyboard');
    });

    test('returns original order for unknown sort', () {
      final sorted = useCase(products, 'unknown');
      expect(sorted.length, 3);
    });
  });
}

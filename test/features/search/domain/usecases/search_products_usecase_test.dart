import 'package:flutter_test/flutter_test.dart';

class SearchProduct {
  final String id;
  final String name;
  final String description;

  SearchProduct({
    required this.id,
    required this.name,
    required this.description,
  });
}

class SearchProductsUseCase {
  List<SearchProduct> call(List<SearchProduct> products, String query) {
    final lowerQuery = query.toLowerCase();
    return products
        .where((product) =>
            product.name.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

void main() {
  group('SearchProductsUseCase', () {
    late SearchProductsUseCase useCase;
    late List<SearchProduct> products;

    setUp(() {
      useCase = SearchProductsUseCase();
      products = [
        SearchProduct(id: '1', name: 'Laptop', description: 'High performance computer'),
        SearchProduct(id: '2', name: 'Mouse', description: 'Wireless mouse'),
        SearchProduct(id: '3', name: 'Keyboard', description: 'Mechanical keyboard'),
      ];
    });

    test('returns all matching products by name', () {
      expect(useCase(products, 'Laptop').length, 1);
    });

    test('returns all matching products by description', () {
      expect(useCase(products, 'wireless').length, 1);
    });

    test('returns empty list for no matches', () {
      expect(useCase(products, 'Monitor').length, 0);
    });

    test('returns case-insensitive matches', () {
      expect(useCase(products, 'LAPTOP').length, 1);
    });

    test('returns multiple matches', () {
      expect(useCase(products, 'computer').length, 1);
    });
  });
}

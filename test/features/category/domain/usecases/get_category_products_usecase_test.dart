import 'package:flutter_test/flutter_test.dart';

class CategoryProduct {
  final String id;
  final String name;
  final String category;

  CategoryProduct({
    required this.id,
    required this.name,
    required this.category,
  });
}

class GetCategoryProductsUseCase {
  List<CategoryProduct> call(List<CategoryProduct> products, String category) {
    return products.where((product) => product.category == category).toList();
  }
}

void main() {
  group('GetCategoryProductsUseCase', () {
    late GetCategoryProductsUseCase useCase;
    late List<CategoryProduct> products;

    setUp(() {
      useCase = GetCategoryProductsUseCase();
      products = [
        CategoryProduct(id: '1', name: 'Laptop', category: 'Electronics'),
        CategoryProduct(id: '2', name: 'Mouse', category: 'Electronics'),
        CategoryProduct(id: '3', name: 'Shirt', category: 'Clothing'),
      ];
    });

    test('returns products for specific category', () {
      expect(useCase(products, 'Electronics').length, 2);
    });

    test('returns empty list for non-existent category', () {
      expect(useCase(products, 'Books').length, 0);
    });

    test('returns correct products for clothing category', () {
      final result = useCase(products, 'Clothing');
      expect(result.length, 1);
      expect(result[0].name, 'Shirt');
    });

    test('returns empty list for empty products', () {
      expect(useCase([], 'Electronics').length, 0);
    });

    test('returns all products of category', () {
      final result = useCase(products, 'Electronics');
      expect(result.every((p) => p.category == 'Electronics'), true);
    });
  });
}

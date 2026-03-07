import 'package:flutter_test/flutter_test.dart';

class Category {
  final String id;
  final String name;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    required this.productCount,
  });
}

class GetAllCategoriesUseCase {
  List<Category> call(List<Category> categories) {
    return categories..sort((a, b) => a.name.compareTo(b.name));
  }
}

void main() {
  group('GetAllCategoriesUseCase', () {
    late GetAllCategoriesUseCase useCase;
    late List<Category> categories;

    setUp(() {
      useCase = GetAllCategoriesUseCase();
      categories = [
        Category(id: '1', name: 'Electronics', productCount: 100),
        Category(id: '2', name: 'Clothing', productCount: 200),
        Category(id: '3', name: 'Books', productCount: 50),
      ];
    });

    test('returns all categories', () {
      expect(useCase(categories).length, 3);
    });

    test('sorts categories alphabetically', () {
      final sorted = useCase(categories);
      expect(sorted[0].name, 'Books');
      expect(sorted[2].name, 'Electronics');
    });

    test('returns empty list for empty categories', () {
      expect(useCase([]).length, 0);
    });

    test('preserves category data', () {
      final sorted = useCase(categories);
      expect(sorted[0].productCount, 50);
    });

    test('handles single category', () {
      expect(useCase([categories[0]]).length, 1);
    });
  });
}

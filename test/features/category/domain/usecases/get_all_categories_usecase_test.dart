import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';

void main() {
  group('CategoryEntity - Operations', () {
    late List<CategoryEntity> categories;

    setUp(() {
      categories = [
        CategoryEntity(categoryId: '1', name: 'Electronics'),
        CategoryEntity(categoryId: '2', name: 'Clothing'),
        CategoryEntity(categoryId: '3', name: 'Books'),
      ];
    });

    test('returns all categories', () {
      expect(categories.length, 3);
    });

    test('sorts categories alphabetically', () {
      final sorted = [...categories]..sort((a, b) => a.name.compareTo(b.name));
      expect(sorted[0].name, 'Books');
      expect(sorted[1].name, 'Clothing');
      expect(sorted[2].name, 'Electronics');
    });

    test('returns empty list for empty categories', () {
      expect([].length, 0);
    });

    test('preserves category data', () {
      expect(categories[0].categoryId, '1');
      expect(categories[0].name, 'Electronics');
    });

    test('handles single category', () {
      final single = [categories[0]];
      expect(single.length, 1);
      expect(single[0].name, 'Electronics');
    });

    test('CategoryEntity are equatable', () {
      final cat1 = CategoryEntity(categoryId: '1', name: 'Electronics');
      final cat2 = CategoryEntity(categoryId: '1', name: 'Electronics');
      expect(cat1, equals(cat2));
    });

    test('finds category by categoryId', () {
      final found = categories.firstWhere((c) => c.categoryId == '2');
      expect(found.name, 'Clothing');
    });
  });
}

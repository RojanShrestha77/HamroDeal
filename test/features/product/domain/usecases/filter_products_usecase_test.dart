import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/product/domain/usecases/get_filtered_products_usecase.dart';

void main() {
  group('GetFilteredProductsUsecase - Params', () {
    test('GetFilteredProductsParams creates with all filters', () {
      final params = GetFilteredProductsParams(
        categoryId: 'cat1',
        search: 'laptop',
        minPrice: 50,
        maxPrice: 150,
        sort: 'price_asc',
      );

      expect(params.categoryId, 'cat1');
      expect(params.search, 'laptop');
      expect(params.minPrice, 50);
      expect(params.maxPrice, 150);
      expect(params.sort, 'price_asc');
    });

    test('GetFilteredProductsParams hasFilters returns true when filters applied', () {
      final params = GetFilteredProductsParams(
        minPrice: 100,
        maxPrice: 200,
      );

      expect(params.hasFilters, true);
    });

    test('GetFilteredProductsParams hasFilters returns false when no filters', () {
      final params = GetFilteredProductsParams.empty();

      expect(params.hasFilters, false);
    });

    test('GetFilteredProductsParams.empty() creates empty params', () {
      final params = GetFilteredProductsParams.empty();

      expect(params.categoryId, null);
      expect(params.search, null);
      expect(params.minPrice, null);
      expect(params.maxPrice, null);
      expect(params.sort, null);
    });

    test('GetFilteredProductsParams are equatable', () {
      final params1 = GetFilteredProductsParams(
        minPrice: 100,
        maxPrice: 200,
      );

      final params2 = GetFilteredProductsParams(
        minPrice: 100,
        maxPrice: 200,
      );

      expect(params1, equals(params2));
    });

    test('GetFilteredProductsParams with different values are not equal', () {
      final params1 = GetFilteredProductsParams(minPrice: 100);
      final params2 = GetFilteredProductsParams(minPrice: 200);

      expect(params1, isNot(equals(params2)));
    });
  });
}

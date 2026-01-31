import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity test', () {
    test('stores product name correctly', () {
      const product = ProductEntity(
        productName: 'iPhone',
        description: 'Smartphone',
        price: 50000,
        quantity: 2,
      );
      String expectedValue = 'iPhone';

      String actualValue = product.productName;

      expect(expectedValue, actualValue);
    });

    test('stores price and quantity correctly', () {
      const product = ProductEntity(
        productName: 'Test',
        description: 'Desc',
        price: 99.50,
        quantity: 5,
      );
      double expectedPrice = 99.50;
      int expectedQuantity = 5;

      double actualPrice = product.price;
      int actualQuantity = product.quantity;

      expect(expectedPrice, actualPrice);
      expect(expectedQuantity, actualQuantity);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/order_item_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';

void main() {
  group('OrderEntity - Total Calculation', () {
    late ShippingAddressEntity shippingAddress;

    setUp(() {
      shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main St',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );
    });

    test('OrderEntity calculates itemCount correctly', () {
      final items = [
        OrderItemEntity(
          productId: 'prod1',
          productName: 'Laptop',
          price: 100,
          quantity: 2,
          sellerId: 'seller1',
        ),
        OrderItemEntity(
          productId: 'prod2',
          productName: 'Mouse',
          price: 50,
          quantity: 1,
          sellerId: 'seller1',
        ),
      ];

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: items,
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 250,
        shippingCost: 10,
        tax: 25,
        total: 285,
        status: OrderStatus.pending,
      );

      expect(order.itemCount, 3);
    });

    test('OrderEntity with single item', () {
      final items = [
        OrderItemEntity(
          productId: 'prod1',
          productName: 'Laptop',
          price: 100,
          quantity: 1,
          sellerId: 'seller1',
        ),
      ];

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: items,
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        shippingCost: 0,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(order.total, 110);
      expect(order.itemCount, 1);
    });

    test('OrderEntity with shipping cost', () {
      final items = [
        OrderItemEntity(
          productId: 'prod1',
          productName: 'Laptop',
          price: 100,
          quantity: 1,
          sellerId: 'seller1',
        ),
      ];

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: items,
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        shippingCost: 10,
        tax: 11,
        total: 121,
        status: OrderStatus.pending,
      );

      expect(order.shippingCost, 10);
      expect(order.total, 121);
    });

    test('OrderItemEntity calculates subtotal', () {
      final item = OrderItemEntity(
        productId: 'prod1',
        productName: 'Laptop',
        price: 100,
        quantity: 2,
        sellerId: 'seller1',
      );

      expect(item.subtotal, 200);
    });

    test('OrderEntity are equatable', () {
      final items = [
        OrderItemEntity(
          productId: 'prod1',
          productName: 'Laptop',
          price: 100,
          quantity: 1,
          sellerId: 'seller1',
        ),
      ];

      final order1 = OrderEntity(
        orderNumber: 'ORD001',
        items: items,
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        shippingCost: 0,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      final order2 = OrderEntity(
        orderNumber: 'ORD001',
        items: items,
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        shippingCost: 0,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(order1, equals(order2));
    });
  });
}

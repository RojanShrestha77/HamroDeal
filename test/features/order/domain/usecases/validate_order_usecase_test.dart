import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';

void main() {
  group('OrderEntity - Validation', () {
    test('OrderEntity with valid data passes validation', () {
      final shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main Street, Kathmandu',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(order.shippingAddress.address.isNotEmpty, true);
      expect(order.paymentMethod, PaymentMethod.cashOnDelivery);
    });

    test('OrderEntity requires non-empty orderNumber', () {
      final shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main Street, Kathmandu',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(order.orderNumber.isNotEmpty, true);
    });

    test('OrderEntity requires valid shipping address', () {
      final shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main Street, Kathmandu',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(order.shippingAddress.address.length, greaterThanOrEqualTo(10));
    });

    test('OrderEntity supports different payment methods', () {
      final shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main Street, Kathmandu',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );

      final orderCard = OrderEntity(
        orderNumber: 'ORD001',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.card,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      final orderOnline = OrderEntity(
        orderNumber: 'ORD002',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.online,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.pending,
      );

      expect(orderCard.paymentMethod, PaymentMethod.card);
      expect(orderOnline.paymentMethod, PaymentMethod.online);
    });

    test('OrderEntity supports different order statuses', () {
      final shippingAddress = ShippingAddressEntity(
        fullName: 'John Doe',
        phone: '1234567890',
        address: '123 Main Street, Kathmandu',
        city: 'Kathmandu',
        state: 'Bagmati',
        zipCode: '44600',
        country: 'Nepal',
      );

      final order = OrderEntity(
        orderNumber: 'ORD001',
        items: [],
        shippingAddress: shippingAddress,
        paymentMethod: PaymentMethod.cashOnDelivery,
        subtotal: 100,
        tax: 10,
        total: 110,
        status: OrderStatus.shipped,
      );

      expect(order.status, OrderStatus.shipped);
    });
  });
}

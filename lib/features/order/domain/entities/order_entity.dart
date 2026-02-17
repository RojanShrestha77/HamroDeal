import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/order/domain/entities/order_item_entity.dart';
import 'package:hamro_deal/features/order/domain/entities/shipping_address_entity.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentMethod { cashOnDelivery, card, online }

class OrderEntity extends Equatable {
  final String? id;
  final String? userId;
  final String orderNumber;
  final List<OrderItemEntity> items;
  final ShippingAddressEntity shippingAddress;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final OrderStatus status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    this.id,
    this.userId,
    required this.orderNumber,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.subtotal,
    this.shippingCost = 0,
    this.tax = 0,
    required this.total,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [
    id,
    userId,
    orderNumber,
    items,
    shippingAddress,
    paymentMethod,
    subtotal,
    shippingCost,
    tax,
    total,
    status,
    notes,
    createdAt,
    updatedAt,
  ];
}

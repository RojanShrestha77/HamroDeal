import 'package:hamro_deal/features/order/data/models/order_item_api_model.dart';
import 'package:hamro_deal/features/order/data/models/shipping_address_api_model.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

class OrderApiModel {
  final String? id;
  final String? userId;
  final String orderNumber;
  final List<OrderItemApiModel> items;
  final ShippingAddressApiModel shippingAddress;
  final String paymentMethod;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderApiModel({
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
    this.status = 'pending',
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    return OrderApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] is String
          ? json['userId'] as String?
          : json['userId'] is Map<String, dynamic>
          ? (json['userId'] as Map<String, dynamic>)['_id'] as String?
          : null,

      orderNumber: json['orderNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => OrderItemApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      shippingAddress: ShippingAddressApiModel.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
      paymentMethod: json['paymentMethod'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'orderNumber': orderNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'tax': tax,
      'total': total,
      'status': status,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert to Entity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      orderNumber: orderNumber,
      items: items.map((item) => item.toEntity()).toList(),
      shippingAddress: shippingAddress.toEntity(),
      paymentMethod: _parsePaymentMethod(paymentMethod),
      subtotal: subtotal,
      shippingCost: shippingCost,
      tax: tax,
      total: total,
      status: _parseOrderStatus(status),
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from Entity
  factory OrderApiModel.fromEntity(OrderEntity entity) {
    return OrderApiModel(
      id: entity.id,
      userId: entity.userId,
      orderNumber: entity.orderNumber,
      items: entity.items
          .map((item) => OrderItemApiModel.fromEntity(item))
          .toList(),
      shippingAddress: ShippingAddressApiModel.fromEntity(
        entity.shippingAddress,
      ),
      paymentMethod: _paymentMethodToString(entity.paymentMethod),
      subtotal: entity.subtotal,
      shippingCost: entity.shippingCost,
      tax: entity.tax,
      total: entity.total,
      status: _orderStatusToString(entity.status),
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Helper methods
  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return PaymentMethod.cashOnDelivery;
      case 'card':
        return PaymentMethod.card;
      case 'online':
        return PaymentMethod.online;
      default:
        return PaymentMethod.cashOnDelivery;
    }
  }

  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'cash_on_delivery';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.online:
        return 'online';
    }
  }

  static OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

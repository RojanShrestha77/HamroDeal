import 'package:hamro_deal/features/order/domain/entities/order_item_entity.dart';

class OrderItemApiModel {
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String sellerId;

  OrderItemApiModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.sellerId,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      productId: json['productId'] is String
          ? json['productId'] as String
          : (json['productId'] as Map<String, dynamic>)['_id'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      sellerId: json['sellerId'] is String
          ? json['sellerId'] as String
          : (json['sellerId'] as Map<String, dynamic>)['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'sellerId': sellerId,
    };
  }

  // Convert to Entity
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      price: price,
      sellerId: sellerId,
    );
  }

  // Convert from Entity
  factory OrderItemApiModel.fromEntity(OrderItemEntity entity) {
    return OrderItemApiModel(
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      quantity: entity.quantity,
      price: entity.price,
      sellerId: entity.sellerId,
    );
  }
}

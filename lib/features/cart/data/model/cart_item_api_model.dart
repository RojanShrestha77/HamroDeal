import 'package:hamro_deal/features/cart/domain/entities/cart_item_entity.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';

class CartItemApiModel {
  final String productId;
  final int quantity;
  final double price;
  final ProductApiModel? product;

  CartItemApiModel({
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemApiModel(
      productId: json['productId'] is String
          ? json['productId']
          : json['productId']['_id'],
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      product: json['productId'] is Map
          ? ProductApiModel.fromJson(json['productId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity, 'price': price};
  }

  // Convert to Entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      quantity: quantity,
      price: price,
      product: product?.toEntity(),
    );
  }

  // Convert from Entity
  factory CartItemApiModel.fromEntity(CartItemEntity entity) {
    return CartItemApiModel(
      productId: entity.productId,
      quantity: entity.quantity,
      price: entity.price,
      product: entity.product != null
          ? ProductApiModel.fromEntity(entity.product!)
          : null,
    );
  }
}

import 'package:hamro_deal/features/cart/data/model/cart_item_api_model.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';

class CartApiModel {
  final String? id;
  final String? userId;
  final List<CartItemApiModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartApiModel({
    this.id,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      items: (json['items'] as List)
          .map((item) => CartItemApiModel.fromJson(item))
          .toList(),
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
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods
  double get total {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Convert to Entity
  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from Entity
  factory CartApiModel.fromEntity(CartEntity entity) {
    return CartApiModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items
          .map((item) => CartItemApiModel.fromEntity(item))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

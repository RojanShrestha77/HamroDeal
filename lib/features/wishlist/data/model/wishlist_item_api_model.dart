import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_item_entity.dart';

class WishlistItemApiModel {
  final String productId;
  final DateTime addedAt;
  final ProductApiModel? product;

  WishlistItemApiModel({
    required this.productId,
    required this.addedAt,
    this.product,
  });

  factory WishlistItemApiModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemApiModel(
      productId: json['productId'] is String
          ? json['productId']
          : json['productId']['_id'],
      addedAt: DateTime.parse(json['addedAt'] as String),
      product: json['productId'] is Map
          ? ProductApiModel.fromJson(json['productId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'addedAt': addedAt.toIso8601String()};
  }

  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      productId: productId,
      addedAt: addedAt,
      product: product?.toEntity(),
    );
  }

  factory WishlistItemApiModel.fromEntity(WishlistItemEntity entity) {
    return WishlistItemApiModel(
      productId: entity.productId,
      addedAt: entity.addedAt,
      product: entity.product != null
          ? ProductApiModel.fromEntity(entity.product!)
          : null,
    );
  }
}

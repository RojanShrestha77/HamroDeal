import 'package:hamro_deal/features/wishlist/data/model/wishlist_item_api_model.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';

class WishlistApiModel {
  final String? id;
  final String? userId;
  final List<WishlistItemApiModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WishlistApiModel({
    this.id,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory WishlistApiModel.fromJson(Map<String, dynamic> json) {
    return WishlistApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      items: (json['items'] as List)
          .map((item) => WishlistItemApiModel.fromJson(item))
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

  // Convert to Entity
  WishlistEntity toEntity() {
    return WishlistEntity(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from Entity
  factory WishlistApiModel.fromEntity(WishlistEntity entity) {
    return WishlistApiModel(
      id: entity.id,
      userId: entity.userId,
      items: entity.items
          .map((item) => WishlistItemApiModel.fromEntity(item))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

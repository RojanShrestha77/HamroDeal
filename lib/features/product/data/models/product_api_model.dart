import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

class ProductApiModel {
  final String? id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String? categoryId;
  final String? images;
  final String? sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductApiModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    this.images,
    this.sellerId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      if (images != null) 'images': images,
    };
  }

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    String? extractId(dynamic value) {
      if (value == null) return null;
      if (value is Map) return value['_id'] as String?;
      return value as String?;
    }

    return ProductApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      categoryId: extractId(json['categoryId']),
      sellerId: extractId(json['sellerId']),
      images: json['images'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      productId: id,
      title: title,
      description: description,
      price: price,
      stock: stock,
      categoryId: categoryId,
      images: images,
      sellerId: sellerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.productId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      stock: entity.stock,
      categoryId: entity.categoryId,
      images: entity.images,
      sellerId: entity.sellerId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

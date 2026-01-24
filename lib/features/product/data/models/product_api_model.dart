import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

class ProductApiModel {
  final String? id;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String? category; //categoryId
  final String? media;
  final String? mediaType;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductApiModel({
    this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    this.category,
    this.media,
    this.mediaType,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'description': description,
      'price': 'price',
      'quantity': quantity,
      'category': category,
      if (media != null) 'media': media,
      if (mediaType != null) 'mediaType': mediaType,
      if (status != null) 'status': status,
    };
  }

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    String? extractId(dynamic value) {
      if (value == null) return null;
      if (value is Map) return value['id'] as String?;
      return value as String?;
    }

    return ProductApiModel(
      id: json['_id'] as String?,
      category: extractId(json['category']),
      productName: json['productName'] as String,
      description: json['desciption'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int,
      media: json['media'] as String,
      mediaType: json['mediaType'] as String?,
      status: json['status'] as String?,
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
      productName: productName,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      media: media,
      mediaType: mediaType,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.productId,
      productName: entity.productName,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      category: entity.category,
      media: entity.media,
      mediaType: entity.mediaType,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

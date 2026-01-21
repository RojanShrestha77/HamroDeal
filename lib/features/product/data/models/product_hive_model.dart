import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ProductHiveModel extends HiveObject {
  final String? productId;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;
  final String category;

  ProductHiveModel({
    String? productId,
    required this.title,
    required this.description,
    required this.price,
    this.media,
    this.mediaType,
    required this.quantity,

    bool? isClaimed,
    String? status,
    required this.category,
  }) : productId = productId ?? const Uuid().v4(),
       isClaimed = isClaimed ?? false,
       status = status ?? 'available';

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      title: title,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      status: status,
    );
  }

  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      productId: entity.productId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      category: entity.category,
      media: entity.media,
      mediaType: entity.mediaType,
      isClaimed: entity.isClaimed,
      status: entity.status,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

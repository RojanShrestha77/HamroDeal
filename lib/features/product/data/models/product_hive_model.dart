import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.productTypeId)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? productId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int stock;

  @HiveField(6)
  final String? images;

  @HiveField(7)
  final String? categoryId;

  @HiveField(8)
  final String? sellerId;

  ProductHiveModel({
    this.id,
    String? productId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    this.images,
    this.categoryId,
    this.sellerId,
  }) : productId = productId ?? const Uuid().v4();

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      title: title,
      description: description,
      price: price,
      stock: stock,
      categoryId: categoryId,
      images: images,
      sellerId: sellerId,
    );
  }

  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      productId: entity.productId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      stock: entity.stock,
      categoryId: entity.categoryId,
      images: entity.images,
      sellerId: entity.sellerId,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  factory ProductHiveModel.fromApiModel(ProductApiModel apiModel) {
    return ProductHiveModel(
      productId: apiModel.id,
      title: apiModel.title,
      description: apiModel.description,
      price: apiModel.price,
      stock: apiModel.stock,
      categoryId: apiModel.categoryId,
      images: apiModel.images,
      sellerId: apiModel.sellerId,
    );
  }

  static List<ProductHiveModel> fromApiModelList(
    List<ProductApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => ProductHiveModel.fromApiModel(model))
        .toList();
  }
}

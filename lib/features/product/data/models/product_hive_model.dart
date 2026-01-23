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
  final String productName;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  final String? media;

  @HiveField(7)
  final String? mediaType;

  @HiveField(8)
  final bool isClaimed;

  @HiveField(9)
  final String? status;

  @HiveField(10)
  final String? category;

  ProductHiveModel({
    this.id,
    String? productId,
    required this.productName,
    required this.description,
    required this.price,
    this.media,
    this.mediaType,
    required this.quantity,

    bool? isClaimed,
    String? status,
    this.category,
  }) : productId = productId ?? const Uuid().v4(),
       isClaimed = isClaimed ?? false,
       status = status ?? 'available';

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      productName: productName,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      media: media,
      mediaType: mediaType,
      status: status,
    );
  }

  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      productId: entity.productId,
      productName: entity.productName,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      category: entity.category,
      media: entity.media,
      mediaType: entity.mediaType,
      status: entity.status,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // cache
  // convert the api model into the hive model for caching
  factory ProductHiveModel.fromApiModel(ProductApiModel apiModel) {
    return ProductHiveModel(
      productId: apiModel.id,
      category: apiModel.category,
      productName: apiModel.productName,
      description: apiModel.description,
      price: apiModel.price,
      quantity: apiModel.quantity,
      media: apiModel.media,
      mediaType: apiModel.mediaType,
      status: apiModel.status,
    );
  }

  // convert list of Api models to Hive models
  static List<ProductHiveModel> fromApiModelList(
    List<ProductApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => ProductHiveModel.fromApiModel(model))
        .toList();
  }
}

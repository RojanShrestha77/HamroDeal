import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';

class CategoryApiModel {
  final String? id;
  final String name;
  final String? description;
  final String? status;

  CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, if (description != null) 'desciption': description};
  }

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['_id'] as String?,
      name: json['_name'] as String,
      description: json['_description'] as String?,
      status: json['_status'] as String?,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id,
      name: name,
      description: description,
      status: status,
    );
  }

  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.categoryId,
      name: entity.name,
      description: entity.description,
      status: entity.status,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

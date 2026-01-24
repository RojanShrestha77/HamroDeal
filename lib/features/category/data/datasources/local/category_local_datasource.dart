import 'package:hamro_deal/features/category/data/datasources/category_datasource.dart';
import 'package:hamro_deal/features/category/data/models/category_hive_model.dart';

class CategoryLocalDatasource implements ICategoryDatasource {
  @override
  Future<bool> createCategory(CategoryHiveModel category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCategory(String categoryId) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryHiveModel>> getAllCategories() {
    // TODO: implement getAllCategories
    throw UnimplementedError();
  }

  @override
  Future<CategoryHiveModel?> getCategoryById(String categoryId) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateCategory(CategoryHiveModel category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}

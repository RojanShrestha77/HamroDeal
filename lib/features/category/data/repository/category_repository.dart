import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:hamro_deal/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:hamro_deal/features/category/data/models/category_api_model.dart';
import 'package:hamro_deal/features/category/data/models/category_hive_model.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';
import 'package:hamro_deal/features/category/domain/repository/category_repository.dart';

// provider
final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryLocalDatasource = ref.read(categoryLocalDatasourceProvider);
  final categoryRemoteDatasource = ref.read(categoryRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return CategoryRepository(
    categoryLocalDatasource: categoryLocalDatasource,
    categoryRemoteDatasource: categoryRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final CategoryRemoteDatasource _categoryRemoteDatasource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required CategoryLocalDatasource categoryLocalDatasource,
    required CategoryRemoteDatasource categoryRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _categoryLocalDatasource = categoryLocalDatasource,
       _categoryRemoteDatasource = categoryRemoteDatasource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, bool>> createCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryLocalDatasource.createCategory(
        categoryModel,
      );
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: 'Failed to create category'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String categoryId) async {
    try {
      final result = await _categoryLocalDatasource.deleteCategory(categoryId);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: 'Failed to delete the category'),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _categoryRemoteDatasource.getAllCategories();
        // cache all the data locally for offline accesss
        final hiveModels = CategoryHiveModel.fromApiModelList(models);
        await _categoryLocalDatasource.cacheAllCategories(hiveModels);
        final entities = CategoryApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return _getCachedCategories();
      }
    } else {
      return _getCachedCategories();
    }
  }

  // helper method for the getCacheCatgories
  Future<Either<Failure, List<CategoryEntity>>> _getCachedCategories() async {
    try {
      final models = await _categoryLocalDatasource.getAllCategories();
      final entities = CategoryHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    try {
      final model = await _categoryLocalDatasource.getCategoryById(categoryId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: 'category not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryLocalDatasource.updateCategory(
        categoryModel,
      );
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

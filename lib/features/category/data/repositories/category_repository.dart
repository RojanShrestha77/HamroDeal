import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:hamro_deal/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:hamro_deal/features/category/data/models/category_api_model.dart';
import 'package:hamro_deal/features/category/data/models/category_hive_model.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';
import 'package:hamro_deal/features/category/domain/repositories/category_repository.dart';

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
    // print('🔵 [Repo] getAllCategories called');
    // print('🔵 [Repo] Checking network connection...');

    if (await _networkInfo.isConnected) {
      // print('🟢 [Repo] Network connected - fetching from API');
      try {
        final models = await _categoryRemoteDatasource.getAllCategories();
        // print('🟢 [Repo] API returned ${models.length} categories');

        // cache all the data locally for offline access
        final hiveModels = CategoryHiveModel.fromApiModelList(models);
        await _categoryLocalDatasource.cacheAllCategories(hiveModels);
        // print('🟢 [Repo] Cached ${hiveModels.length} categories to Hive');

        final entities = CategoryApiModel.toEntityList(models);
        // print('🟢 [Repo] Returning ${entities.length} entities');
        return Right(entities);
      } catch (e) {
        // print('🔴 [Repo] API failed: $e');
        // print('🔴 [Repo] Falling back to cache');
        return _getCachedCategories();
      }
    } else {
      // print('🔴 [Repo] No network - using cache');
      return _getCachedCategories();
    }
  }

  Future<Either<Failure, List<CategoryEntity>>> _getCachedCategories() async {
    try {
      final models = await _categoryLocalDatasource.getAllCategories();
      // print('🟢 [Repo] Got ${models.length} cached categories');
      final entities = CategoryHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      // print('🔴 [Repo] Cache retrieval failed: $e');
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

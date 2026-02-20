import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/product/data/datasources/local/product_local_datasource.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:hamro_deal/features/product/data/models/product_api_model.dart';
import 'package:hamro_deal/features/product/data/models/product_hive_model.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final localDatasource = ref.read(productLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final remoteDataSource = ref.read(productRemoteDatasourceProvider);
  return ProductRepository(
    localDataSource: localDatasource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class ProductRepository extends IProductRepository {
  final ProductLocalDatasource _localDataSource;
  final IProductRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProductRepository({
    required ProductLocalDatasource localDataSource,
    required IProductRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, bool>> createProduct(ProductEntity product) async {
    if (await _networkInfo.isConnected) {
      try {
        final productApiModel = ProductApiModel.fromEntity(product);
        await _remoteDataSource.createProduct(productApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(LocalDatabaseFailure(message: 'No internet available'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteProduct(productId);

        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteProduct(productId);
        if (result) {
          return const Right(true);
        } else {
          return Left(LocalDatabaseFailure(message: 'Failed to delete item'));
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllProducts();
        // cache the data
        final hiveModels = ProductHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllProducts(hiveModels);
        final entities = ProductApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return _getCachedItems();
      }
    } else {
      return _getCachedItems();
    }
  }

  // helper method to get the cached items
  Future<Either<Failure, List<ProductEntity>>> _getCachedItems() async {
    try {
      final models = await _localDataSource.getAllProducts();
      final entities = ProductHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getProductsByCategory(
          categoryId,
        );
        final entities = ProductApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getProductsByCategory(categoryId);
        final entities = ProductHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductsById(
    String productId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getProductById(productId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getProductsById(productId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'Item not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(ProductEntity product) async {
    if (await _networkInfo.isConnected) {
      try {
        final productApiModel = ProductApiModel.fromEntity(product);
        await _remoteDataSource.updateProduct(productApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final productHiveModel = ProductHiveModel.fromEntity(product);
        final result = await _localDataSource.updateProduct(productHiveModel);
        if (result) {
          return const Right(true);
        } else {
          return Left(
            LocalDatabaseFailure(message: 'unable to update product'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadImage(photo);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadVideo(video);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByUser(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getProductsByUser(userId);
        final entities = ProductApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getProductsByUser(userId);
        final entities = ProductHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFilteredProducts({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getFilteredProducts(
          categoryId: categoryId,
          search: search,
          minPrice: minPrice,
          maxPrice: maxPrice,
          sort: sort,
        );

        // caching
        final hiveModels = ProductHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllProducts(hiveModels);

        final entites = ProductApiModel.toEntityList(models);
        return Right(entites);
      } catch (e) {
        return _getFilteredCachedProducts(
          categoryId: categoryId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          sort: sort,
        );
      }
    } else {
      // no offline for search
      if (search != null && search.isNotEmpty) {
        return const Left(
          ApiFailure(message: 'Search requires internet connection'),
        );
      }

      return _getFilteredCachedProducts(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
      );
    }
  }

  // helpermetyhod
  Future<Either<Failure, List<ProductEntity>>> _getFilteredCachedProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    try {
      final models = await _localDataSource.getFilteredProducts(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
      );
      final entities = ProductHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

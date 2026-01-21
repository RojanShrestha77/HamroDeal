import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class ProductRepository extends IProductRepository {
  final IProductLocalDataSource _productDataSource;
  final IProductRemoteDataSource _productRemoteDataSource;
  final NetworkInfo _networkInfo;

  ProductRepository({
    required IProductLocalDataSource productDataSource,
    required IProductRemoteDataSource productRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _productDataSource = productDataSource,
       _productRemoteDataSource = productRemoteDataSource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, bool>> createProduct(ProductEntity product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) {
    // TODO: implement getProductsByCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductsById(String productId) {
    // TODO: implement getProductsById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateProduct(ProductEntity product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _productRemoteDataSource.uploadImage(photo);
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
        final url = await _productRemoteDataSource.uploadVideo(video);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet Connection'));
    }
  }
}

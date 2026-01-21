import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

abstract class IProductRepository {
  Future<Either<Failure, bool>> createProduct(ProductEntity product);
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();
  Future<Either<Failure, ProductEntity>> getProductsById(String productId);
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );
  Future<Either<Failure, bool>> updateProduct(ProductEntity product);
  Future<Either<Failure, bool>> deleteProduct(String productId);
  Future<Either<Failure, String>> uploadPhoto(File photo);
  Future<Either<Failure, String>> uploadVideo(File video);
}

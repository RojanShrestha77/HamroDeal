import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, List<CategoryEntity>>> getCategoryById(
    String categoryId,
  );
  Future<Either<Failure, bool>> createCategory(CategoryEntity category);
  Future<Either<Failure, bool>> updateCategory(CategoryEntity category);
  Future<Either<Failure, bool>> deloeteCategory(String categoryId);
}

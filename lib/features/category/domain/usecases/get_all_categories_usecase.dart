import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/category/data/repository/category_repository.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';
import 'package:hamro_deal/features/category/domain/repository/category_repository.dart';

final getAllCategoriesUsecaseProvider = Provider((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetAllCategoriesUsecase(categoryRepository: categoryRepository);
});

class GetAllCategoriesUsecase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  GetAllCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _categoryRepository.getAllCategories();
  }
}

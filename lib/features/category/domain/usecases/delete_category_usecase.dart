import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/category/data/repositories/category_repository.dart';
import 'package:hamro_deal/features/category/domain/repositories/category_repository.dart';

class DeleteCategoryParams extends Equatable {
  final String categoryId;

  const DeleteCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

// provider
final deleteCategoryUsecaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);

  return DeleteCategoryUseCase(categoryRepository: categoryRepository);
});

class DeleteCategoryUseCase
    implements UsecaseWithParams<bool, DeleteCategoryParams> {
  final ICategoryRepository _categoryRepository;

  DeleteCategoryUseCase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteCategoryParams params) {
    return _categoryRepository.deleteCategory(params.categoryId);
  }
}

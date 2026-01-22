import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

final getAllProductsUsecaseProvider = Provider<GetAllProductsUsecase>((ref) {
  final itemRepository = ref.read(productRepositoryProvider);
  return GetAllProductsUsecase(itemRepository: itemRepository);
});

class GetAllProductsUsecase
    implements UsecaseWithoutParams<List<ProductEntity>> {
  final IProductRepository _productRepository;

  GetAllProductsUsecase({required IProductRepository itemRepository})
    : _productRepository = itemRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call() {
    return _productRepository.getAllProducts();
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class DeleteProductParams extends Equatable {
  final String productId;

  DeleteProductParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final deleteProductUsecaseProvider = Provider<DeleteProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return DeleteProductUsecase(productRepository: productRepository);
});

class DeleteProductUsecase
    implements UsecaseWithParams<bool, DeleteProductParams> {
  final IProductRepository _productRepository;

  DeleteProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteProductParams params) {
    return _productRepository.deleteProduct(params.productId);
  }
}

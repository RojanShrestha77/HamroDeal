import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class GetProductByIdParams extends Equatable {
  final String productId;

  const GetProductByIdParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final getProductsByIdUsecaseProvider = Provider<GetProductByIdUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return GetProductByIdUsecase(productRepository: productRepository);
});

class GetProductByIdUsecase
    implements UsecaseWithParams<ProductEntity, GetProductByIdParams> {
  final IProductRepository _productRepository;

  GetProductByIdUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;
  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) {
    return _productRepository.getProductsById(params.productId);
  }
}

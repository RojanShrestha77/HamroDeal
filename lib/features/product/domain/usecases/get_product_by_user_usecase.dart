import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class GetProductByUserParams extends Equatable {
  final String userId;

  const GetProductByUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getProductsByUserUsecaseProvider = Provider<GetProductByUserUsecase>((
  ref,
) {
  final productRepository = ref.read(productRepositoryProvider);
  return GetProductByUserUsecase(productRepository: productRepository);
});

class GetProductByUserUsecase
    implements UsecaseWithParams<List<ProductEntity>, GetProductByUserParams> {
  final IProductRepository _productRepository;

  GetProductByUserUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductByUserParams params,
  ) {
    return _productRepository.getProductsByUser(params.userId);
  }
}

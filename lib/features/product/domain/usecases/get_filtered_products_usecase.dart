import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class GetFilteredProductsParams extends Equatable {
  final String? categoryId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const GetFilteredProductsParams({
    this.categoryId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  // helper methiod to check if any filter is applied
  bool get hasFilters =>
      categoryId != null ||
      search != null ||
      minPrice != null ||
      maxPrice != null ||
      sort != null;

  //  create empty filter
  factory GetFilteredProductsParams.empty() =>
      const GetFilteredProductsParams();

  @override
  List<Object?> get props => [categoryId, search, minPrice, maxPrice, sort];
}

final getFilteredProductsUsecaseProvider = Provider<GetFilteredProductsUsecase>(
  (ref) {
    final productRepository = ref.read(productRepositoryProvider);
    return GetFilteredProductsUsecase(productRepository: productRepository);
  },
);

class GetFilteredProductsUsecase
    implements
        UsecaseWithParams<List<ProductEntity>, GetFilteredProductsParams> {
  final IProductRepository _productRepository;

  GetFilteredProductsUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetFilteredProductsParams params,
  ) {
    return _productRepository.getFilteredProducts(
      categoryId: params.categoryId,
      search: params.search,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      sort: params.sort,
    );
  }
}

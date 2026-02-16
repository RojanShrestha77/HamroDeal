import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class UpdateProductParams extends Equatable {
  final String? productId;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final String? images;

  const UpdateProductParams({
    this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.images,
  });

  @override
  List<Object?> get props => [
    productId,
    title,
    description,
    price,
    stock,
    categoryId,
    images,
  ];
}

final updateProductUsecaseProvider = Provider<UpdateProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return UpdateProductUsecase(productRepository: productRepository);
});

class UpdateProductUsecase
    implements UsecaseWithParams<bool, UpdateProductParams> {
  final IProductRepository _productRepository;

  UpdateProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProductParams params) {
    final productEntity = ProductEntity(
      productId: params.productId,
      title: params.title,
      description: params.description,
      price: params.price,
      stock: params.stock,
      categoryId: params.categoryId,
      images: params.images,
    );
    return _productRepository.updateProduct(productEntity);
  }
}

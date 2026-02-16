import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class CreateProductParams extends Equatable {
  final String title;
  final String description;
  final double price;
  final int stock;
  final String categoryId;
  final String? images;

  const CreateProductParams({
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.images,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    price,
    stock,
    categoryId,
    images,
  ];
}

final createProductUsecaseProvider = Provider<CreateProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return CreateProductUsecase(productRepository: productRepository);
});

class CreateProductUsecase
    implements UsecaseWithParams<bool, CreateProductParams> {
  final IProductRepository _productRepository;

  CreateProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, bool>> call(CreateProductParams params) {
    final productEntity = ProductEntity(
      title: params.title,
      description: params.description,
      categoryId: params.categoryId,
      price: params.price,
      stock: params.stock,
      images: params.images,
    );
    return _productRepository.createProduct(productEntity);
  }
}

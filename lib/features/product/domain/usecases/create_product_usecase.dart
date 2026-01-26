import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

class CreateProductParams extends Equatable {
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final String? media;
  final String? mediaType;

  const CreateProductParams({
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.media,
    this.mediaType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    productName,
    description,
    price,
    quantity,
    category,
    media,
    mediaType,
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
      productName: params.productName,
      description: params.description,
      category: params.category,
      price: params.price,
      quantity: params.quantity,
      media: params.media,
      mediaType: params.mediaType,
    );

    return _productRepository.createProduct(productEntity);
  }
}

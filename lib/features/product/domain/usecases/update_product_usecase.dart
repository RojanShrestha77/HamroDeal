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
  final int quantity;
  final String category;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;

  const UpdateProductParams({
    this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.media,
    this.mediaType,

    this.isClaimed = false,
    this.status,
  });
  @override
  List<Object?> get props => [
    productId,
    title,
    description,
    price,
    quantity,
    category,
    media,
    mediaType,
    isClaimed,
    status,
  ];
}

final updateUsecaseProvider = Provider<UpdateProductUsecase>((ref) {
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
    final porductEntity = ProductEntity(
      productId: params.productId,
      title: params.title,
      description: params.description,
      price: params.price,
      quantity: params.quantity,
      category: params.category,
      media: params.media,
      mediaType: params.mediaType,
      isClaimed: params.isClaimed,
      status: params.status,
    );

    return _productRepository.updateProduct(porductEntity);
  }
}

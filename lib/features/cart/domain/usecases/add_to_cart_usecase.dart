import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/cart/data/repositories/cart_repository.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

class AddToCartParams extends Equatable {
  final String productId;
  final int quantity;

  const AddToCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  return AddToCartUsecase(cartRepository: ref.read(cartRepositoryProvider));
});

class AddToCartUsecase
    implements UsecaseWithParams<CartEntity, AddToCartParams> {
  final ICartRepository _cartRepository;

  AddToCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartParams params) {
    return _cartRepository.addToCart(params.productId, params.quantity);
  }
}

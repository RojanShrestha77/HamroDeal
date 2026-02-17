import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/cart/data/repositories/cart_repository.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItemParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartItemParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

final updateCartItemUsecaseProvider = Provider<UpdateCartItemUsecase>((ref) {
  return UpdateCartItemUsecase(
    cartRepository: ref.read(cartRepositoryProvider),
  );
});

class UpdateCartItemUsecase
    implements UsecaseWithParams<CartEntity, UpdateCartItemParams> {
  final ICartRepository _cartRepository;

  UpdateCartItemUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartEntity>> call(UpdateCartItemParams params) {
    return _cartRepository.updateCartItem(params.productId, params.quantity);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/cart/data/repositories/cart_repository.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  return GetCartUsecase(cartRepository: ref.read(cartRepositoryProvider));
});

class GetCartUsecase implements UsecaseWithoutParams<CartEntity> {
  final ICartRepository _cartRepository;

  GetCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartEntity>> call() {
    return _cartRepository.getCart();
  }
}

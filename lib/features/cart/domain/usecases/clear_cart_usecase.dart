import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/cart/data/repositories/cart_repository.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

final clearCartUsecaseProvider = Provider<ClearCartUsecase>((ref) {
  return ClearCartUsecase(cartRepository: ref.read(cartRepositoryProvider));
});

class ClearCartUsecase implements UsecaseWithoutParams<bool> {
  final ICartRepository _cartRepository;

  ClearCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _cartRepository.clearCart();
  }
}

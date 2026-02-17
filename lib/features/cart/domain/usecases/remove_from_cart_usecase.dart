import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/cart/data/repositories/cart_repository.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartParams extends Equatable {
  final String productId;

  const RemoveFromCartParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final removeFromCartUsecaseProvider = Provider<RemoveFromCartUsecase>((ref) {
  return RemoveFromCartUsecase(
    cartRepository: ref.read(cartRepositoryProvider),
  );
});

class RemoveFromCartUsecase
    implements UsecaseWithParams<bool, RemoveFromCartParams> {
  final ICartRepository _cartRepository;

  RemoveFromCartUsecase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call(RemoveFromCartParams params) {
    return _cartRepository.removeFromCart(params.productId);
  }
}

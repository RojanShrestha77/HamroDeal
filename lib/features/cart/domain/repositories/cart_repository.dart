import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, CartEntity>> addToCart(String productId, int quantity);
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> updateCartItem(
    String productId,
    int quantity,
  );
  Future<Either<Failure, bool>> removeFromCart(String productId);
  Future<Either<Failure, bool>> clearCart();
}

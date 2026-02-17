import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';

abstract interface class IWishlistRepository {
  Future<Either<Failure, WishlistEntity>> addToWishlist(String productId);
  Future<Either<Failure, WishlistEntity>> getWishlist();
  Future<Either<Failure, bool>> removeFromWishlist(String productId);
  Future<Either<Failure, bool>> clearWishlist();
}

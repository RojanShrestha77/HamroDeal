import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:hamro_deal/features/wishlist/domain/repositories/wihslist_repository.dart';

final getWishlistUsecaseProvider = Provider<GetWishlistUsecase>((ref) {
  return GetWishlistUsecase(
    wishlistRepository: ref.read(wishlistRepositoryProvider),
  );
});

class GetWishlistUsecase implements UsecaseWithoutParams<WishlistEntity> {
  final IWishlistRepository _wishlistRepository;

  GetWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call() {
    return _wishlistRepository.getWishlist();
  }
}

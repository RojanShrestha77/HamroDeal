import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:hamro_deal/features/wishlist/domain/repositories/wihslist_repository.dart';

final clearWishlistUsecaseProvider = Provider<ClearWishlistUsecase>((ref) {
  return ClearWishlistUsecase(
    wishlistRepository: ref.read(wishlistRepositoryProvider),
  );
});

class ClearWishlistUsecase implements UsecaseWithoutParams<bool> {
  final IWishlistRepository _wishlistRepository;

  ClearWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _wishlistRepository.clearWishlist();
  }
}

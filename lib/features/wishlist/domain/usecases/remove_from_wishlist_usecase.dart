import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:hamro_deal/features/wishlist/domain/repositories/wihslist_repository.dart';

class RemoveFromWishlistParams extends Equatable {
  final String productId;

  const RemoveFromWishlistParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final removeFromWishlistUsecaseProvider = Provider<RemoveFromWishlistUsecase>((
  ref,
) {
  return RemoveFromWishlistUsecase(
    wishlistRepository: ref.read(wishlistRepositoryProvider),
  );
});

class RemoveFromWishlistUsecase
    implements UsecaseWithParams<bool, RemoveFromWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  RemoveFromWishlistUsecase({required IWishlistRepository wishlistRepository})
    : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call(RemoveFromWishlistParams params) {
    return _wishlistRepository.removeFromWishlist(params.productId);
  }
}

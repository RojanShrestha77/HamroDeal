import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:hamro_deal/features/wishlist/domain/usecases/clear_wishlist_usecase.dart';
import 'package:hamro_deal/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:hamro_deal/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:hamro_deal/features/wishlist/presentation/state/wishlist_state.dart';

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(
      () => WishlistViewModel(),
    );

class WishlistViewModel extends Notifier<WishlistState> {
  late final GetWishlistUsecase _getWishlistUsecase;
  late final AddToWishlistUsecase _addToWishlistUsecase;
  late final RemoveFromWishlistUsecase _removeFromWishlistUsecase;
  late final ClearWishlistUsecase _clearWishlistUsecase;

  @override
  WishlistState build() {
    _getWishlistUsecase = ref.read(getWishlistUsecaseProvider);
    _addToWishlistUsecase = ref.read(addToWishlistUsecaseProvider);
    _removeFromWishlistUsecase = ref.read(removeFromWishlistUsecaseProvider);
    _clearWishlistUsecase = ref.read(clearWishlistUsecaseProvider);
    return const WishlistState();
  }

  // Get wishlist
  Future<void> getWishlist() async {
    state = state.copyWith(
      status: WishlistStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getWishlistUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: WishlistStatus.error,
          errorMessage: failure.message,
        );
      },
      (wishlist) {
        state = state.copyWith(
          status: WishlistStatus.loaded,
          wishlist: wishlist,
          resetErrorMessage: true,
        );
      },
    );
  }

  // Add to wishlist
  Future<bool> addToWishlist(String productId) async {
    state = state.copyWith(
      status: WishlistStatus.loading,
      resetErrorMessage: true,
    );

    final params = AddToWishlistParams(productId: productId);
    final result = await _addToWishlistUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: WishlistStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (wishlist) {
        state = state.copyWith(
          status: WishlistStatus.itemAdded,
          wishlist: wishlist,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // Remove from wishlist
  Future<bool> removeFromWishlist(String productId) async {
    state = state.copyWith(
      status: WishlistStatus.loading,
      resetErrorMessage: true,
    );

    final params = RemoveFromWishlistParams(productId: productId);
    final result = await _removeFromWishlistUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: WishlistStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        // Refresh wishlist after removal
        getWishlist();
        return true;
      },
    );
  }

  // Clear wishlist
  Future<bool> clearWishlist() async {
    state = state.copyWith(
      status: WishlistStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _clearWishlistUsecase();

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: WishlistStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          status: WishlistStatus.wishlistCleared,
          resetWishlist: true,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    if (state.wishlist == null) return false;
    return state.wishlist!.items.any((item) => item.productId == productId);
  }

  // Reset error
  void resetError() {
    state = state.copyWith(resetErrorMessage: true);
  }
}

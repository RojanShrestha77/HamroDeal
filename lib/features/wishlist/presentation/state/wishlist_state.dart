import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';

enum WishlistStatus {
  initial,
  loading,
  loaded,
  error,
  itemAdded,
  itemRemoved,
  wishlistCleared,
}

class WishlistState extends Equatable {
  final WishlistStatus status;
  final WishlistEntity? wishlist;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.wishlist,
    this.errorMessage,
  });

  WishlistState copyWith({
    WishlistStatus? status,
    WishlistEntity? wishlist,
    String? errorMessage,
    bool resetErrorMessage = false,
    bool resetWishlist = false,
  }) {
    return WishlistState(
      status: status ?? this.status,
      wishlist: resetWishlist ? null : (wishlist ?? this.wishlist),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, wishlist, errorMessage];
}

import 'package:hamro_deal/features/wishlist/data/model/wishlist_api_model.dart';

abstract interface class IWishlistRemoteDataSource {
  Future<WishlistApiModel> addToWishlist(String productId);
  Future<WishlistApiModel> getWishlist();
  Future<bool> removeFromWishlist(String productId);
  Future<bool> clearWishlist();
}

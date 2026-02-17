import 'package:hamro_deal/features/cart/data/model/cart_api_model.dart';

abstract interface class ICartRemoteDataSource {
  Future<CartApiModel> addToCart(String productId, int quantity);
  Future<CartApiModel> getCart();
  Future<CartApiModel> updateCartItem(String productId, int quantity);
  Future<bool> removeFromCart(String productId);
  Future<bool> clearCart();
}

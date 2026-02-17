import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:hamro_deal/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:hamro_deal/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:hamro_deal/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:hamro_deal/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:hamro_deal/features/cart/presentation/state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);

class CartViewModel extends Notifier<CartState> {
  late final GetCartUsecase _getCartUsecase;
  late final AddToCartUsecase _addToCartUsecase;
  late final UpdateCartItemUsecase _updateCartItemUsecase;
  late final RemoveFromCartUsecase _removeFromCartUsecase;
  late final ClearCartUsecase _clearCartUsecase;

  @override
  CartState build() {
    _getCartUsecase = ref.read(getCartUsecaseProvider);
    _addToCartUsecase = ref.read(addToCartUsecaseProvider);
    _updateCartItemUsecase = ref.read(updateCartItemUsecaseProvider);
    _removeFromCartUsecase = ref.read(removeFromCartUsecaseProvider);
    _clearCartUsecase = ref.read(clearCartUsecaseProvider);
    return const CartState();
  }

  // Get cart
  Future<void> getCart() async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final result = await _getCartUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          resetErrorMessage: true,
        );
      },
    );
  }

  // Add to cart
  Future<bool> addToCart(String productId, int quantity) async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final params = AddToCartParams(productId: productId, quantity: quantity);
    final result = await _addToCartUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.itemAdded,
          cart: cart,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // Update cart item quantity
  Future<bool> updateCartItem(String productId, int quantity) async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final params = UpdateCartItemParams(
      productId: productId,
      quantity: quantity,
    );
    final result = await _updateCartItemUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.itemUpdated,
          cart: cart,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // Remove from cart
  Future<bool> removeFromCart(String productId) async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final params = RemoveFromCartParams(productId: productId);
    final result = await _removeFromCartUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        // Refresh cart after removal
        getCart();
        return true;
      },
    );
  }

  // Clear cart
  Future<bool> clearCart() async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final result = await _clearCartUsecase();

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          status: CartStatus.cartCleared,
          resetCart: true,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // Reset error
  void resetError() {
    state = state.copyWith(resetErrorMessage: true);
  }
}

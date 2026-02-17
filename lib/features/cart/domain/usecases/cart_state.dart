import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';

class CartState {
  final bool isLoading;
  final CartEntity? cart;
  final String? error;

  CartState({required this.isLoading, this.cart, this.error});

  factory CartState.initial() {
    return CartState(isLoading: false, cart: null, error: null);
  }

  CartState copyWith({bool? isLoading, CartEntity? cart, String? error}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      error: error ?? this.error,
    );
  }
}

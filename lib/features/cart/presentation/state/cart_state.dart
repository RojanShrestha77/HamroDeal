import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
  itemAdded,
  itemUpdated,
  itemRemoved,
  cartCleared,
}

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    bool resetErrorMessage = false,
    bool resetCart = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: resetCart ? null : (cart ?? this.cart),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}

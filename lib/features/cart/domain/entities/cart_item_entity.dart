import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final int quantity;
  final double price;
  final ProductEntity? product;

  const CartItemEntity({
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [productId, quantity, price, product];
}

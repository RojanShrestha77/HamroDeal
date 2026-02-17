import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double price;
  final String sellerId;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.price,
    required this.sellerId,
  });

  double get subtotal => price * quantity;

  @override
  // TODO: implement props
  List<Object?> get props => [
    productId,
    productName,
    productImage,
    quantity,
    price,
    sellerId,
  ];
}

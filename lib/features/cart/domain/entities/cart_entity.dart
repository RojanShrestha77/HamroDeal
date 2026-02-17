import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final String? userId;
  final List<CartItemEntity> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartEntity({
    this.id,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  double get total {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [id, userId, items, createdAt, updatedAt];
}

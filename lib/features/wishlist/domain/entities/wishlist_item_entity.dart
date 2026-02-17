import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

class WishlistItemEntity extends Equatable {
  final String productId;
  final DateTime addedAt;
  final ProductEntity? product;

  const WishlistItemEntity({
    required this.productId,
    required this.addedAt,
    this.product,
  });

  @override
  List<Object?> get props => [productId, addedAt, product];
}

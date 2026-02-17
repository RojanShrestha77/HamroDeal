import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_item_entity.dart';

class WishlistEntity extends Equatable {
  final String? id;
  final String? userId;
  final List<WishlistItemEntity> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WishlistEntity({
    this.id,
    this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.length;

  @override
  List<Object?> get props => [id, userId, items, createdAt, updatedAt];
}

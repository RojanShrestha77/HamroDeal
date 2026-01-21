import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;

  const ProductEntity({
    this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.media,
    this.mediaType,

    this.isClaimed = false,
    this.status,
  });

  @override
  List<Object?> get props => [
    productId,
    title,
    description,
    price,
    quantity,
    category,
    media,
    mediaType,
    isClaimed,
    status,
  ];
}

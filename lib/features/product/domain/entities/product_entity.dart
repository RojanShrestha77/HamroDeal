import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String? category;
  final String? media;
  final String? mediaType;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    this.category,
    this.media,
    this.mediaType,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    description,
    price,
    quantity,
    category,
    media,
    mediaType,
    status,
    createdAt,
    updatedAt,
  ];
}

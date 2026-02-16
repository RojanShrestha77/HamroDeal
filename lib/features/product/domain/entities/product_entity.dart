import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String? categoryId;
  final String? images;
  final String? sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    this.images,
    this.sellerId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    productId,
    title,
    description,
    price,
    stock,
    categoryId,
    images,
    sellerId,
    createdAt,
    updatedAt,
  ];
}

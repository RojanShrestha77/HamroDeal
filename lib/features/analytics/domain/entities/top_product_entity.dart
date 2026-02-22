import 'package:equatable/equatable.dart';

class TopProductEntity extends Equatable {
  final String id;
  final String productName;
  final String? productImage;
  final int totalSold;
  final double totalRevenue;

  const TopProductEntity({
    required this.id,
    required this.productName,
    this.productImage,
    required this.totalSold,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [
    id,
    productName,
    productImage,
    totalSold,
    totalRevenue,
  ];
}

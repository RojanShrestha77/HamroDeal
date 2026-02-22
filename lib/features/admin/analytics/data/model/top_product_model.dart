import '../../domain/entities/top_product_entity.dart';

class TopProductModel {
  final String id;
  final String productName;
  final String? productImage;
  final int totalSold;
  final double totalRevenue;

  TopProductModel({
    required this.id,
    required this.productName,
    this.productImage,
    required this.totalSold,
    required this.totalRevenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'],
      totalSold: json['totalSold'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
    );
  }

  TopProductEntity toEntity() {
    return TopProductEntity(
      id: id,
      productName: productName,
      productImage: productImage,
      totalSold: totalSold,
      totalRevenue: totalRevenue,
    );
  }
}

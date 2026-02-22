import '../../domain/entities/revenue_data_entity.dart';

class RevenueDataModel {
  final String date;
  final double revenue;
  final int orders;

  RevenueDataModel({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  factory RevenueDataModel.fromJson(Map<String, dynamic> json) {
    return RevenueDataModel(
      date: json['date'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }

  RevenueDataEntity toEntity() {
    return RevenueDataEntity(date: date, revenue: revenue, orders: orders);
  }
}

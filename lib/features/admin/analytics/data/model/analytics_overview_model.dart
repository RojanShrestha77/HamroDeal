import '../../domain/entities/analytics_overview_entity.dart';

class AnalyticsOverviewModel {
  final RevenueStatsModel revenue;
  final OrderStatsModel orders;
  final UserStatsModel users;
  final ProductStatsModel products;

  AnalyticsOverviewModel({
    required this.revenue,
    required this.orders,
    required this.users,
    required this.products,
  });

  factory AnalyticsOverviewModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverviewModel(
      revenue: RevenueStatsModel.fromJson(json['revenue']),
      orders: OrderStatsModel.fromJson(json['orders']),
      users: UserStatsModel.fromJson(json['users']),
      products: ProductStatsModel.fromJson(json['products']),
    );
  }

  AnalyticsOverviewEntity toEntity() {
    return AnalyticsOverviewEntity(
      revenue: revenue.toEntity(),
      orders: orders.toEntity(),
      users: users.toEntity(),
      products: products.toEntity(),
    );
  }
}

class RevenueStatsModel {
  final double allTime;
  final double thisMonth;

  RevenueStatsModel({required this.allTime, required this.thisMonth});

  factory RevenueStatsModel.fromJson(Map<String, dynamic> json) {
    return RevenueStatsModel(
      allTime: (json['allTime'] ?? 0).toDouble(),
      thisMonth: (json['thisMonth'] ?? 0).toDouble(),
    );
  }

  RevenueStatsEntity toEntity() {
    return RevenueStatsEntity(allTime: allTime, thisMonth: thisMonth);
  }
}

class OrderStatsModel {
  final int total;
  final int pending;
  final int processing;
  final int shipped;
  final int delivered;
  final int cancelled;

  OrderStatsModel({
    required this.total,
    required this.pending,
    required this.processing,
    required this.shipped,
    required this.delivered,
    required this.cancelled,
  });

  factory OrderStatsModel.fromJson(Map<String, dynamic> json) {
    return OrderStatsModel(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      processing: json['processing'] ?? 0,
      shipped: json['shipped'] ?? 0,
      delivered: json['delivered'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }

  OrderStatsEntity toEntity() {
    return OrderStatsEntity(
      total: total,
      pending: pending,
      processing: processing,
      shipped: shipped,
      delivered: delivered,
      cancelled: cancelled,
    );
  }
}

class UserStatsModel {
  final int total;
  final int buyers;
  final int sellers;
  final int admins;

  UserStatsModel({
    required this.total,
    required this.buyers,
    required this.sellers,
    required this.admins,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      total: json['total'] ?? 0,
      buyers: json['buyers'] ?? 0,
      sellers: json['sellers'] ?? 0,
      admins: json['admins'] ?? 0,
    );
  }

  UserStatsEntity toEntity() {
    return UserStatsEntity(
      total: total,
      buyers: buyers,
      sellers: sellers,
      admins: admins,
    );
  }
}

class ProductStatsModel {
  final int total;
  final int lowStock;

  ProductStatsModel({required this.total, required this.lowStock});

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductStatsModel(
      total: json['total'] ?? 0,
      lowStock: json['lowStock'] ?? 0,
    );
  }

  ProductStatsEntity toEntity() {
    return ProductStatsEntity(total: total, lowStock: lowStock);
  }
}

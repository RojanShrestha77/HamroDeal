import 'package:equatable/equatable.dart';

class AnalyticsOverviewEntity extends Equatable {
  final RevenueStatsEntity revenue;
  final OrderStatsEntity orders;
  final UserStatsEntity users;
  final ProductStatsEntity products;

  const AnalyticsOverviewEntity({
    required this.revenue,
    required this.orders,
    required this.users,
    required this.products,
  });

  @override
  List<Object?> get props => [revenue, orders, users, products];
}

class RevenueStatsEntity extends Equatable {
  final double allTime;
  final double thisMonth;

  const RevenueStatsEntity({required this.allTime, required this.thisMonth});

  @override
  List<Object?> get props => [allTime, thisMonth];
}

class OrderStatsEntity extends Equatable {
  final int total;
  final int pending;
  final int processing;
  final int shipped;
  final int delivered;
  final int cancelled;

  const OrderStatsEntity({
    required this.total,
    required this.pending,
    required this.processing,
    required this.shipped,
    required this.delivered,
    required this.cancelled,
  });

  @override
  List<Object?> get props => [
    total,
    pending,
    processing,
    shipped,
    delivered,
    cancelled,
  ];
}

class UserStatsEntity extends Equatable {
  final int total;
  final int buyers;
  final int sellers;
  final int admins;

  const UserStatsEntity({
    required this.total,
    required this.buyers,
    required this.sellers,
    required this.admins,
  });

  @override
  List<Object?> get props => [total, buyers, sellers, admins];
}

class ProductStatsEntity extends Equatable {
  final int total;
  final int lowStock;

  const ProductStatsEntity({required this.total, required this.lowStock});

  @override
  List<Object?> get props => [total, lowStock];
}

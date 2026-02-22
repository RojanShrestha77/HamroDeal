import 'package:equatable/equatable.dart';

class RevenueDataEntity extends Equatable {
  final String date;
  final double revenue;
  final int orders;

  const RevenueDataEntity({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  @override
  List<Object?> get props => [date, revenue, orders];
}

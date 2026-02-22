import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/admin/analytics/domain/entities/analytics_overview_entity.dart';
import 'package:hamro_deal/features/admin/analytics/domain/entities/revenue_data_entity.dart';
import 'package:hamro_deal/features/admin/analytics/domain/entities/top_product_entity.dart';

enum AdminAnalyticsStatus { initial, loading, success, error }

class AdminAnalyticsState extends Equatable {
  final AdminAnalyticsStatus status;
  final AnalyticsOverviewEntity? overview;
  final List<RevenueDataEntity> revenueData;
  final List<TopProductEntity> topProducts;
  final String? errorMessage;

  const AdminAnalyticsState({
    this.status = AdminAnalyticsStatus.initial,
    this.overview,
    this.revenueData = const [],
    this.topProducts = const [],
    this.errorMessage,
  });

  AdminAnalyticsState copyWith({
    AdminAnalyticsStatus? status,
    AnalyticsOverviewEntity? overview,
    List<RevenueDataEntity>? revenueData,
    List<TopProductEntity>? topProducts,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return AdminAnalyticsState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      revenueData: revenueData ?? this.revenueData,
      topProducts: topProducts ?? this.topProducts,
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    overview,
    revenueData,
    topProducts,
    errorMessage,
  ];
}

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import '../entities/analytics_overview_entity.dart';
import '../entities/revenue_data_entity.dart';
import '../entities/top_product_entity.dart';

abstract class IAdminAnalyticsRepository {
  Future<Either<Failure, AnalyticsOverviewEntity>> getOverview();
  Future<Either<Failure, List<RevenueDataEntity>>> getRevenueData(
    String startDate,
    String endDate,
  );
  Future<Either<Failure, List<TopProductEntity>>> getTopProducts(int limit);
}

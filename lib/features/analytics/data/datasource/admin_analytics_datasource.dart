import 'package:hamro_deal/features/analytics/data/model/analytics_overview_model.dart';
import 'package:hamro_deal/features/analytics/data/model/revenue_data_model.dart';
import 'package:hamro_deal/features/analytics/data/model/top_product_model.dart';

abstract class IAdminAnalyticsDataSource {
  Future<AnalyticsOverviewModel> getOverview();
  Future<List<RevenueDataModel>> getRevenueData(
    String startDate,
    String endDate,
  );
  Future<List<TopProductModel>> getTopProducts(int limit);
}

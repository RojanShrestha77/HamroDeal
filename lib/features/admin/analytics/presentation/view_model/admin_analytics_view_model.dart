import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/admin/analytics/domain/usecases/get_overview_usecase.dart';
import 'package:hamro_deal/features/admin/analytics/domain/usecases/get_revenue_data_usecase.dart';
import 'package:hamro_deal/features/admin/analytics/domain/usecases/get_top_products_usecase.dart';
import 'package:hamro_deal/features/admin/analytics/presentation/state/admin_analytics_state.dart';

final adminAnalyticsViewModelProvider =
    NotifierProvider<AdminAnalyticsViewModel, AdminAnalyticsState>(() {
      return AdminAnalyticsViewModel();
    });

class AdminAnalyticsViewModel extends Notifier<AdminAnalyticsState> {
  late final GetOverviewUsecase _getOverviewUsecase;
  late final GetRevenueDataUsecase _getRevenueDataUsecase;
  late final GetTopProductsUsecase _getTopProductsUsecase;

  @override
  AdminAnalyticsState build() {
    _getOverviewUsecase = ref.watch(getOverviewUsecaseProvider);
    _getRevenueDataUsecase = ref.watch(getRevenueDataUsecaseProvider);
    _getTopProductsUsecase = ref.watch(getTopProductsUsecaseProvider);
    return const AdminAnalyticsState();
  }

  Future<void> loadAnalytics() async {
    state = state.copyWith(status: AdminAnalyticsStatus.loading);

    // Calculate date range
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));
    final startDateStr = startDate.toIso8601String().split('T')[0];
    final endDateStr = endDate.toIso8601String().split('T')[0];

    final overviewResult = await _getOverviewUsecase();
    final revenueResult = await _getRevenueDataUsecase(
      startDateStr,
      endDateStr,
    );
    final topProductsResult = await _getTopProductsUsecase(5);

    overviewResult.fold(
      (failure) {
        state = state.copyWith(
          status: AdminAnalyticsStatus.error,
          errorMessage: failure.message,
        );
      },
      (overview) {
        revenueResult.fold(
          (failure) {
            state = state.copyWith(
              status: AdminAnalyticsStatus.error,
              errorMessage: failure.message,
            );
          },
          (revenueData) {
            topProductsResult.fold(
              (failure) {
                state = state.copyWith(
                  status: AdminAnalyticsStatus.error,
                  errorMessage: failure.message,
                );
              },
              (topProducts) {
                state = state.copyWith(
                  status: AdminAnalyticsStatus.success,
                  overview: overview,
                  revenueData: revenueData,
                  topProducts: topProducts,
                );
              },
            );
          },
        );
      },
    );
  }
}

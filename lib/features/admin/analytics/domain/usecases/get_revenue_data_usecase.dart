import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/analytics/data/repositories/admin_analytics_repository.dart';
import '../entities/revenue_data_entity.dart';
import '../repositories/admin_analytics_repository.dart';

final getRevenueDataUsecaseProvider = Provider<GetRevenueDataUsecase>((ref) {
  return GetRevenueDataUsecase(
    repository: ref.read(adminAnalyticsRepositoryProvider),
  );
});

class GetRevenueDataUsecase {
  final IAdminAnalyticsRepository _repository;

  GetRevenueDataUsecase({required IAdminAnalyticsRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<RevenueDataEntity>>> call(
    String startDate,
    String endDate,
  ) async {
    return await _repository.getRevenueData(startDate, endDate);
  }
}

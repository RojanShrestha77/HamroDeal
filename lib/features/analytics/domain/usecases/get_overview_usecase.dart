import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/analytics/data/repositories/admin_analytics_repository.dart';
import '../entities/analytics_overview_entity.dart';
import '../repositories/admin_analytics_repository.dart';

final getOverviewUsecaseProvider = Provider<GetOverviewUsecase>((ref) {
  return GetOverviewUsecase(
    repository: ref.read(adminAnalyticsRepositoryProvider),
  );
});

class GetOverviewUsecase {
  final IAdminAnalyticsRepository _repository;

  GetOverviewUsecase({required IAdminAnalyticsRepository repository})
    : _repository = repository;

  Future<Either<Failure, AnalyticsOverviewEntity>> call() async {
    return await _repository.getOverview();
  }
}

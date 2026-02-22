import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/analytics/data/repositories/admin_analytics_repository.dart';
import '../entities/top_product_entity.dart';
import '../repositories/admin_analytics_repository.dart';

final getTopProductsUsecaseProvider = Provider<GetTopProductsUsecase>((ref) {
  return GetTopProductsUsecase(
    repository: ref.read(adminAnalyticsRepositoryProvider),
  );
});

class GetTopProductsUsecase {
  final IAdminAnalyticsRepository _repository;

  GetTopProductsUsecase({required IAdminAnalyticsRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<TopProductEntity>>> call(int limit) async {
    return await _repository.getTopProducts(limit);
  }
}

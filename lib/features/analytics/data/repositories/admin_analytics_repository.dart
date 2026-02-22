import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/analytics/data/datasource/admin_analytics_datasource.dart';
import 'package:hamro_deal/features/analytics/data/datasource/remote/admin_analytics_remote_datasource.dart';
import '../../domain/repositories/admin_analytics_repository.dart';
import '../../domain/entities/analytics_overview_entity.dart';
import '../../domain/entities/revenue_data_entity.dart';
import '../../domain/entities/top_product_entity.dart';

final adminAnalyticsRepositoryProvider = Provider<IAdminAnalyticsRepository>((
  ref,
) {
  return AdminAnalyticsRepository(
    remoteDataSource: ref.read(adminAnalyticsRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class AdminAnalyticsRepository implements IAdminAnalyticsRepository {
  final IAdminAnalyticsDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminAnalyticsRepository({
    required IAdminAnalyticsDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AnalyticsOverviewEntity>> getOverview() async {
    if (await _networkInfo.isConnected) {
      try {
        final overviewModel = await _remoteDataSource.getOverview();
        return Right(overviewModel.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ??
                'Failed to fetch analytics overview',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<RevenueDataEntity>>> getRevenueData(
    String startDate,
    String endDate,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final revenueModels = await _remoteDataSource.getRevenueData(
          startDate,
          endDate,
        );
        return Right(revenueModels.map((model) => model.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to fetch revenue data',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TopProductEntity>>> getTopProducts(
    int limit,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final productModels = await _remoteDataSource.getTopProducts(limit);
        return Right(productModels.map((model) => model.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to fetch top products',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/admin/orders/data/datasource/admin_order_datasource.dart';
import 'package:hamro_deal/features/admin/orders/data/datasource/remote/admin_order_remote_datasource.dart';
import 'package:hamro_deal/features/admin/orders/domain/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

final adminOrderRepositoryProvider = Provider<IAdminOrderRepository>((ref) {
  return AdminOrderRepository(
    remoteDataSource: ref.read(adminOrderRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class AdminOrderRepository implements IAdminOrderRepository {
  final IAdminOrderRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminOrderRepository({
    required IAdminOrderRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    if (await _networkInfo.isConnected) {
      try {
        final orders = await _remoteDataSource.getAllOrders();
        return Right(orders.map((model) => model.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch orders',
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
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    if (await _networkInfo.isConnected) {
      try {
        final order = await _remoteDataSource.getOrderById(orderId);
        return Right(order.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch order',
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
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final order = await _remoteDataSource.updateOrderStatus(
          orderId,
          status,
        );
        return Right(order.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to update order status',
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
  Future<Either<Failure, void>> deleteOrder(String orderId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteOrder(orderId);
        return const Right(null);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to delete order',
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

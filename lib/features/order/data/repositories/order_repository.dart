import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/order/data/datasource/order_datasource.dart';
import 'package:hamro_deal/features/order/data/datasource/remote/order_remote_datasource.dart';
import 'package:hamro_deal/features/order/data/models/order_api_model.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

final orderRepositoryProvider = Provider((ref) {
  return OrderRepository(
    remoteDataSource: ref.watch(orderRemoteDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

class OrderRepository implements IOrderRepository {
  final IOrderRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  OrderRepository({
    required IOrderRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId) async {
    if (await _networkInfo.isConnected) {
      try {
        final order = await _remoteDataSource.cancelOrder(orderId);
        return Right(order.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to cancel order',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet available'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    if (await _networkInfo.isConnected) {
      try {
        final orderModel = OrderApiModel.fromEntity(order);
        final createdOrder = await _remoteDataSource.createOrder(orderModel);
        return Right(createdOrder.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to create order',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet available'));
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
            message: e.response?.data['message'] ?? 'Failed to get order',
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
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() async {
    if (await _networkInfo.isConnected) {
      try {
        final orders = await _remoteDataSource.getUserOrders();
        return Right(orders.map((order) => order.toEntity()).toList());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to get orders',
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

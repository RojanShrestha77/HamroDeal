import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

abstract interface class IOrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, List<OrderEntity>>> getUserOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId);
  
  // Seller orders
  Future<Either<Failure, List<OrderEntity>>> getSellerOrders();
  Future<Either<Failure, OrderEntity>> getSellerOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> updateSellerOrderStatus(String orderId, String status);
}

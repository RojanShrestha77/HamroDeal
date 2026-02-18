import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

abstract class IAdminOrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  );
  Future<Either<Failure, void>> deleteOrder(String orderId);
}

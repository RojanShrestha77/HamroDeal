import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

final cancelOrderUsecaseProvider = Provider<CancelOrderUsecase>((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return CancelOrderUsecase(orderRepository: orderRepository);
});

final class CancelOrderParams extends Equatable {
  final String orderId;

  const CancelOrderParams({required this.orderId});
  @override
  List<Object?> get props => [orderId];
}

class CancelOrderUsecase
    implements UsecaseWithParams<OrderEntity, CancelOrderParams> {
  final IOrderRepository _orderRepository;

  CancelOrderUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(CancelOrderParams params) {
    return _orderRepository.cancelOrder(params.orderId);
  }
}

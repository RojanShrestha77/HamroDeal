import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

final getOrderByIdUsecaseProvider = Provider((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return GetOrderByIdUsecase(orderRepository: orderRepository);
});

final class GetOrderByIdParams extends Equatable {
  final String orderId;

  const GetOrderByIdParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class GetOrderByIdUsecase
    implements UsecaseWithParams<OrderEntity, GetOrderByIdParams> {
  final IOrderRepository _orderRepository;

  GetOrderByIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(GetOrderByIdParams params) {
    return _orderRepository.getOrderById(params.orderId);
  }
}

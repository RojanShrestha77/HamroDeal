import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

final createOrderUsecaseProvider = Provider<CreateOrderUsecase>((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return CreateOrderUsecase(orderRepository: orderRepository);
});

final class CreateOrderParams extends Equatable {
  final OrderEntity order;

  const CreateOrderParams({required this.order});

  @override
  List<Object?> get props => [order];
}

class CreateOrderUsecase
    implements UsecaseWithParams<OrderEntity, CreateOrderParams> {
  final IOrderRepository _orderRepository;

  CreateOrderUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) {
    return _orderRepository.createOrder(params.order);
  }
}

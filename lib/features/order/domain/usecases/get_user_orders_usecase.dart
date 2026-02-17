import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

final getUserOrdersUsecaseProvider = Provider<GetUserOrdersUsecase>((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return GetUserOrdersUsecase(orderRepository: orderRepository);
});

class GetUserOrdersUsecase implements UsecaseWithoutParams<List<OrderEntity>> {
  final IOrderRepository _orderRepository;

  GetUserOrdersUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return _orderRepository.getUserOrders();
  }
}

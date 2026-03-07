import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

class UpdateSellerOrderStatusParams extends Equatable {
  final String orderId;
  final String status;

  const UpdateSellerOrderStatusParams({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}

final updateSellerOrderStatusUsecaseProvider =
    Provider<UpdateSellerOrderStatusUsecase>((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return UpdateSellerOrderStatusUsecase(orderRepository: orderRepository);
});

class UpdateSellerOrderStatusUsecase
    implements UsecaseWithParams<OrderEntity, UpdateSellerOrderStatusParams> {
  final IOrderRepository _orderRepository;

  UpdateSellerOrderStatusUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(
    UpdateSellerOrderStatusParams params,
  ) {
    return _orderRepository.updateSellerOrderStatus(
      params.orderId,
      params.status,
    );
  }
}

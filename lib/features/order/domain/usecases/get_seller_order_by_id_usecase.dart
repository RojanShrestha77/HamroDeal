import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/order/data/repositories/order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/repositories/order_repositories.dart';

class GetSellerOrderByIdParams extends Equatable {
  final String orderId;

  const GetSellerOrderByIdParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final getSellerOrderByIdUsecaseProvider = Provider<GetSellerOrderByIdUsecase>((ref) {
  final OrderRepository orderRepository = ref.watch(orderRepositoryProvider);
  return GetSellerOrderByIdUsecase(orderRepository: orderRepository);
});

class GetSellerOrderByIdUsecase
    implements UsecaseWithParams<OrderEntity, GetSellerOrderByIdParams> {
  final IOrderRepository _orderRepository;

  GetSellerOrderByIdUsecase({required IOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, OrderEntity>> call(GetSellerOrderByIdParams params) {
    return _orderRepository.getSellerOrderById(params.orderId);
  }
}

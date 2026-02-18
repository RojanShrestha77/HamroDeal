import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/orders/data/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/admin/orders/domain/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

final getAllOrdersUsecaseProvider = Provider<GetAllOrdersUsecase>((ref) {
  return GetAllOrdersUsecase(
    adminOrderRepository: ref.read(adminOrderRepositoryProvider),
  );
});

class GetAllOrdersUsecase {
  final IAdminOrderRepository _adminOrderRepository;

  GetAllOrdersUsecase({required IAdminOrderRepository adminOrderRepository})
    : _adminOrderRepository = adminOrderRepository;

  Future<Either<Failure, List<OrderEntity>>> call() {
    return _adminOrderRepository.getAllOrders();
  }
}

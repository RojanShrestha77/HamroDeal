import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/orders/data/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/admin/orders/domain/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

final updateOrderStatusUsecaseProvider = Provider<UpdateOrderStatusUsecase>((
  ref,
) {
  return UpdateOrderStatusUsecase(
    adminOrderRepository: ref.read(adminOrderRepositoryProvider),
  );
});

class UpdateOrderStatusUsecase {
  final IAdminOrderRepository _adminOrderRepository;

  UpdateOrderStatusUsecase({
    required IAdminOrderRepository adminOrderRepository,
  }) : _adminOrderRepository = adminOrderRepository;

  Future<Either<Failure, OrderEntity>> call(String orderId, String status) {
    return _adminOrderRepository.updateOrderStatus(orderId, status);
  }
}

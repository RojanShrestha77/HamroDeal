import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/admin/orders/data/repositories/admin_order_repository.dart';
import 'package:hamro_deal/features/admin/orders/domain/repositories/admin_order_repository.dart';

final deleteOrderUsecaseProvider = Provider<DeleteOrderUsecase>((ref) {
  return DeleteOrderUsecase(
    adminOrderRepository: ref.read(adminOrderRepositoryProvider),
  );
});

class DeleteOrderUsecase {
  final IAdminOrderRepository _adminOrderRepository;

  DeleteOrderUsecase({required IAdminOrderRepository adminOrderRepository})
    : _adminOrderRepository = adminOrderRepository;

  Future<Either<Failure, void>> call(String orderId) {
    return _adminOrderRepository.deleteOrder(orderId);
  }
}

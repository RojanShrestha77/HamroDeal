import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/admin/orders/domain/usecases/delete_order_usecase.dart';
import 'package:hamro_deal/features/admin/orders/domain/usecases/get_all_usecase.dart';
import 'package:hamro_deal/features/admin/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:hamro_deal/features/admin/orders/presentation/state/admin_order_state.dart';

final adminOrderViewModelProvider =
    NotifierProvider<AdminOrderViewModel, AdminOrderState>(
      () => AdminOrderViewModel(),
    );

class AdminOrderViewModel extends Notifier<AdminOrderState> {
  late final GetAllOrdersUsecase _getAllOrdersUsecase;
  late final UpdateOrderStatusUsecase _updateOrderStatusUsecase;
  late final DeleteOrderUsecase _deleteOrderUsecase;

  @override
  AdminOrderState build() {
    _getAllOrdersUsecase = ref.watch(getAllOrdersUsecaseProvider);
    _updateOrderStatusUsecase = ref.watch(updateOrderStatusUsecaseProvider);
    _deleteOrderUsecase = ref.watch(deleteOrderUsecaseProvider);
    return const AdminOrderState();
  }

  // get all orders
  Future<void> getAllOrders() async {
    state = state.copyWith(
      status: AdminOrderViewStatus.loading,
      resetErrorMessage: true,
    );
    final result = await _getAllOrdersUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminOrderViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(
          status: AdminOrderViewStatus.loaded,
          orders: orders,
          resetErrorMessage: true,
        );
      },
    );
  }

  // update status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    state = state.copyWith(
      status: AdminOrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _updateOrderStatusUsecase(orderId, status);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminOrderViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (updatedOrder) {
        // updating the oirder
        final updatedOrders = state.orders.map((order) {
          return order.id == orderId ? updatedOrder : order;
        }).toList();

        state = state.copyWith(
          status: AdminOrderViewStatus.statusUpdated,
          orders: updatedOrders,
          currentOrder: updatedOrder,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // delete order
  Future<bool> deleteOrder(String orderId) async {
    state = state.copyWith(
      status: AdminOrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _deleteOrderUsecase(orderId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminOrderViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final updatedOrders = state.orders
            .where((order) => order.id != orderId)
            .toList();

        state = state.copyWith(
          status: AdminOrderViewStatus.orderDeleted,
          orders: updatedOrders,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  void resetError() {
    state = state.copyWith(resetErrorMessage: true);
  }
}

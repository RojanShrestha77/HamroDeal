import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:hamro_deal/features/order/domain/usecases/create_order_usecase.dart';
import 'package:hamro_deal/features/order/domain/usecases/get_order_by_id_usecase.dart';
import 'package:hamro_deal/features/order/domain/usecases/get_user_orders_usecase.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';

final orderViewModelProvider = NotifierProvider<OrderViewModel, OrderState>(
  () => OrderViewModel(),
);

class OrderViewModel extends Notifier<OrderState> {
  late final CreateOrderUsecase _createOrderUsecase;
  late final GetUserOrdersUsecase _getUserOrdersUsecase;
  late final GetOrderByIdUsecase _getOrderByIdUsecase;
  late final CancelOrderUsecase _cancelOrderUsecase;

  @override
  OrderState build() {
    _createOrderUsecase = ref.watch(createOrderUsecaseProvider);
    _getUserOrdersUsecase = ref.watch(getUserOrdersUsecaseProvider);
    _getOrderByIdUsecase = ref.watch(getOrderByIdUsecaseProvider);
    _cancelOrderUsecase = ref.watch(cancelOrderUsecaseProvider);
    return const OrderState();
  }

  // create order
  Future<bool> createOrder(OrderEntity order) async {
    state = state.copyWith(
      status: OrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final params = CreateOrderParams(order: order);
    final result = await _createOrderUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (createdOrder) {
        state = state.copyWith(
          status: OrderViewStatus.orderCreated,
          currentOrder: createdOrder,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // get user orders
  Future<void> getUserOrders() async {
    state = state.copyWith(
      status: OrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getUserOrdersUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(
          status: OrderViewStatus.loaded,
          orders: orders,
          resetErrorMessage: true,
        );
      },
    );
  }

  // get order by id
  Future<void> getOrderById(String orderId) async {
    state = state.copyWith(
      status: OrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final params = GetOrderByIdParams(orderId: orderId);
    final result = await _getOrderByIdUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(
          status: OrderViewStatus.loaded,
          currentOrder: order,
          resetErrorMessage: true,
        );
      },
    );
  }

  // cancel order
  Future<bool> cancelOrder(String orderId) async {
    state = state.copyWith(
      status: OrderViewStatus.loading,
      resetErrorMessage: true,
    );

    final params = CancelOrderParams(orderId: orderId);
    final result = await _cancelOrderUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (cancelledOrder) {
        state = state.copyWith(
          status: OrderViewStatus.orderCancelled,
          currentOrder: cancelledOrder,
          resetErrorMessage: true,
        );
        getUserOrders();
        return true;
      },
    );
  }

  void resetError() {
    state = state.copyWith(resetErrorMessage: true);
  }
}

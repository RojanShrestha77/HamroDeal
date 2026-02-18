import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

enum AdminOrderViewStatus {
  inital,
  loading,
  loaded,
  error,
  statusUpdated,
  orderDeleted,
}

class AdminOrderState extends Equatable {
  final AdminOrderViewStatus status;
  final List<OrderEntity> orders;
  final OrderEntity? currentOrder;
  final String? errorMessage;

  const AdminOrderState({
    this.status = AdminOrderViewStatus.inital,
    this.orders = const [],
    this.currentOrder,
    this.errorMessage,
  });

  AdminOrderState copyWith({
    AdminOrderViewStatus? status,
    List<OrderEntity>? orders,
    OrderEntity? currentOrder,
    String? errorMessage,
    bool resetErrorMessage = false,
    bool resetCurrentOrder = false,
  }) {
    return AdminOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentOrder: resetCurrentOrder
          ? null
          : (currentOrder ?? this.currentOrder),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, orders, currentOrder, errorMessage];
}

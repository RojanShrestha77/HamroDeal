import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';

enum OrderViewStatus {
  // Changed from OrderStatus
  initial,
  loading,
  loaded,
  error,
  orderCreated,
  orderCancelled,
  orderUpdated,
}

class OrderState extends Equatable {
  final OrderViewStatus status; // Changed type
  final List<OrderEntity> orders;
  final List<OrderEntity> sellerOrders;
  final OrderEntity? currentOrder;
  final String? errorMessage;

  const OrderState({
    this.status = OrderViewStatus.initial, // Changed default
    this.orders = const [],
    this.sellerOrders = const [],
    this.currentOrder,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderViewStatus? status, // Changed type
    List<OrderEntity>? orders,
    List<OrderEntity>? sellerOrders,
    OrderEntity? currentOrder,
    String? errorMessage,
    bool resetErrorMessage = false,
    bool resetCurrentOrder = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      sellerOrders: sellerOrders ?? this.sellerOrders,
      currentOrder: resetCurrentOrder
          ? null
          : (currentOrder ?? this.currentOrder),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, orders, sellerOrders, currentOrder, errorMessage];
}

import 'package:hamro_deal/features/order/data/models/order_api_model.dart';

abstract interface class IOrderRemoteDataSource {
  Future<OrderApiModel> createOrder(OrderApiModel order);
  Future<List<OrderApiModel>> getUserOrders();
  Future<OrderApiModel> getOrderById(String orderId);
  Future<OrderApiModel> cancelOrder(String orderId);
}

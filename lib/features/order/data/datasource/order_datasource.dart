import 'package:hamro_deal/features/order/data/models/order_api_model.dart';

abstract interface class IOrderRemoteDataSource {
  Future<OrderApiModel> createOrder(OrderApiModel order);
  Future<List<OrderApiModel>> getUserOrders();
  Future<OrderApiModel> getOrderById(String orderId);
  Future<OrderApiModel> cancelOrder(String orderId);
  
  // Seller orders
  Future<List<OrderApiModel>> getSellerOrders();
  Future<OrderApiModel> getSellerOrderById(String orderId);
  Future<OrderApiModel> updateSellerOrderStatus(String orderId, String status);
}

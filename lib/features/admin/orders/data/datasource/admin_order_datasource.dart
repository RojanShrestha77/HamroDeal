import 'package:hamro_deal/features/order/data/models/order_api_model.dart';

abstract class IAdminOrderRemoteDataSource {
  Future<List<OrderApiModel>> getAllOrders();
  Future<OrderApiModel> getOrderById(String orderId);
  Future<OrderApiModel> updateOrderStatus(String orderId, String status);
  Future<void> deleteOrder(String orderId);
}

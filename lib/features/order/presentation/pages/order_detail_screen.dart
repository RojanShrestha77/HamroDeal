import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';
import 'package:hamro_deal/features/order/presentation/widgets/order_detail_widgets.dart';
import 'package:hamro_deal/features/order/presentation/widgets/order_tracking_widgets.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(orderViewModelProvider.notifier)
          .getOrderById(widget.orderId),
    );
  }

  String _mapOrderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);
    final order = orderState.currentOrder;

    // Listen for state changes
    ref.listen<OrderState>(orderViewModelProvider, (previous, next) {
      if (next.status == OrderViewStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.status == OrderViewStatus.orderCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
      ),
      body: orderState.status == OrderViewStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : order == null
          ? const Center(child: Text('Order not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header
                  _buildOrderHeader(order),
                  const SizedBox(height: 24),

                  // Order Tracking Widget
                  if (order.status != OrderStatus.cancelled)
                    OrderTrackingWidget(
                      orderStatus: _mapOrderStatusToString(order.status),
                      orderPlacedDate: order.createdAt,
                      orderPackedDate:
                          order.status == OrderStatus.processing ||
                              order.status == OrderStatus.shipped ||
                              order.status == OrderStatus.delivered
                          ? order.updatedAt
                          : null,
                      assignedToLogisticsDate:
                          order.status == OrderStatus.shipped ||
                              order.status == OrderStatus.delivered
                          ? order.updatedAt
                          : null,
                      outForDeliveryDate: order.status == OrderStatus.delivered
                          ? order.updatedAt
                          : null,
                      deliveredDate: order.status == OrderStatus.delivered
                          ? order.updatedAt
                          : null,
                    ),
                  const SizedBox(height: 24),

                  // Order items
                  OrderDetailWidgets.buildSectionTitle('Order Items'),
                  ...order.items.map((item) => _buildOrderItem(item)),
                  const SizedBox(height: 24),

                  // Shipping address
                  OrderDetailWidgets.buildSectionTitle('Shipping Address'),
                  OrderDetailWidgets.buildShippingAddress(
                    order.shippingAddress,
                  ),
                  const SizedBox(height: 24),

                  // Order summary
                  OrderDetailWidgets.buildPriceSummary(order),
                  const SizedBox(height: 24),

                  // Cancel button
                  if (order.status == OrderStatus.pending)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => _showCancelDialog(order.id!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Cancel Order'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderHeader(OrderEntity order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.orderNumber}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Placed on ${OrderDetailWidgets.formatDate(order.createdAt)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                OrderDetailWidgets.buildStatusChip(order.status),
              ],
            ),
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${order.notes}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.productImage != null
                  ? Image.network(
                      ApiEndpoints.productImage(item.productImage!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 12),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Subtotal
            Text(
              'Rs. ${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(orderViewModelProvider.notifier).cancelOrder(orderId);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

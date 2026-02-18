import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/admin/orders/presentation/state/admin_order_state.dart';
import 'package:hamro_deal/features/admin/orders/presentation/view_model/admin_order_view_model.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';
import 'package:hamro_deal/features/order/presentation/widgets/order_detail_widgets.dart';

class AdminOrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const AdminOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<AdminOrderDetailScreen> createState() =>
      _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState
    extends ConsumerState<AdminOrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(orderViewModelProvider.notifier)
          .getOrderById(widget.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);
    final adminOrderState = ref.watch(adminOrderViewModelProvider);

    // listen for actions
    ref.listen<AdminOrderState>(adminOrderViewModelProvider, (previous, next) {
      if (next.status == AdminOrderViewStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.status == AdminOrderViewStatus.statusUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order status updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
        // refresh order details
        ref.read(orderViewModelProvider.notifier).getOrderById(widget.orderId);
      }
      if (next.status == AdminOrderViewStatus.orderDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        // pop back to order list
        Navigator.of(context).pop();
      }
    });
    if (orderState.status == OrderViewStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (orderState.currentOrder == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),

        body: const Center(child: Text("Order not found")),
      );
    }

    final order = orderState.currentOrder!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(order.id!),
          ),
        ],
      ),
      body: adminOrderState.status == AdminOrderViewStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header
                  _buildOrderHeader(order),
                  const SizedBox(height: 24),

                  // Order items
                  OrderDetailWidgets.buildSectionTitle('Order Items'),
                  ...order.items.map((item) => _buildOrderItem(item)),
                  const SizedBox(height: 24),

                  // Shipping address - USING SHARED WIDGET
                  OrderDetailWidgets.buildSectionTitle('Shipping Address'),
                  OrderDetailWidgets.buildShippingAddress(
                    order.shippingAddress,
                  ),
                  const SizedBox(height: 24),

                  // Order summary - USING SHARED WIDGET
                  OrderDetailWidgets.buildPriceSummary(order),
                  const SizedBox(height: 24),

                  // Update status button
                  _buildUpdateStatusButton(order),
                ],
              ),
            ),
    );
  }

  void _showDeleteConfirmationDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Are you sure you want to delete this order?This action cannot be undone',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(adminOrderViewModelProvider.notifier)
                  .deleteOrder(widget.orderId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OrderDetailWidgets.buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Placed on',
              OrderDetailWidgets.formatDate(order.createdAt),
            ),
            _buildInfoRow(
              'Payment Method',
              OrderDetailWidgets.getPaymentMethodText(order.paymentMethod),
            ),
            if (order.notes != null && order.notes!.isNotEmpty)
              _buildInfoRow('Notes', order.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product: ${item.productName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item.quantity} × Rs. ${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              'Rs. ${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateStatusButton(OrderEntity order) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showUpdateStatusDialog(order),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Update Order Status'),
      ),
    );
  }

  void _showUpdateStatusDialog(OrderEntity order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption('pending', 'Pending', order.status),
            _buildStatusOption('processing', 'Processing', order.status),
            _buildStatusOption('shipped', 'Shipped', order.status),
            _buildStatusOption('delivered', 'Delivered', order.status),
            _buildStatusOption('cancelled', 'Cancelled', order.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(
    String statusValue,
    String statusLabel,
    OrderStatus currentStatus,
  ) {
    final isCurrentStatus =
        OrderDetailWidgets.getStatusString(currentStatus) == statusValue;
    return ListTile(
      title: Text(statusLabel),
      trailing: isCurrentStatus
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      enabled: !isCurrentStatus,
      onTap: isCurrentStatus
          ? null
          : () {
              Navigator.pop(context);
              _updateStatus(statusValue);
            },
    );
  }

  void _updateStatus(String status) {
    ref
        .read(adminOrderViewModelProvider.notifier)
        .updateOrderStatus(widget.orderId, status);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

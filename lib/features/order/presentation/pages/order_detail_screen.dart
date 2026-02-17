import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';

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
    // Load order details
    Future.microtask(
      () => ref
          .read(orderViewModelProvider.notifier)
          .getOrderById(widget.orderId),
    );
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
      appBar: AppBar(title: const Text('Order Details')),
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

                  // Order items
                  _buildSectionTitle('Order Items'),
                  ...order.items.map((item) => _buildOrderItem(item)),
                  const SizedBox(height: 24),

                  // Shipping address
                  _buildSectionTitle('Shipping Address'),
                  _buildShippingAddress(order),
                  const SizedBox(height: 24),

                  // Order summary
                  _buildSectionTitle('Order Summary'),
                  _buildOrderSummary(order),
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
                  'Placed on ${_formatDate(order.createdAt)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                _buildStatusChip(order.status),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildShippingAddress(OrderEntity order) {
    final address = order.shippingAddress;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(address.phone),
            const SizedBox(height: 4),
            Text(address.address),
            Text('${address.city}, ${address.state ?? ''} ${address.zipCode}'),
            Text(address.country),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(OrderEntity order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', order.subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow('Shipping', order.shippingCost),
            const SizedBox(height: 8),
            _buildSummaryRow('Tax', order.tax),
            const Divider(height: 24),
            _buildSummaryRow('Total', order.total, isTotal: true),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method'),
                Text(_getPaymentMethodText(order.paymentMethod)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          'Rs. ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Theme.of(context).primaryColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Card Payment';
      case PaymentMethod.online:
        return 'Online Payment';
    }
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/order/domain/entities/order_entity.dart';
import 'package:hamro_deal/features/order/presentation/pages/order_detail_screen.dart';
import 'package:hamro_deal/features/order/presentation/state/order_state.dart';
import 'package:hamro_deal/features/order/presentation/view_model/order_view_model.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(orderViewModelProvider.notifier).getUserOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);

    // listen for errors
    ref.listen<OrderState>(orderViewModelProvider, (previous, next) {
      if (next.status == OrderViewStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orderState.status == OrderViewStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : orderState.orders.isEmpty
          ? _buildEmptyOrders()
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(orderViewModelProvider.notifier).getUserOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orderState.orders.length,
                itemBuilder: (context, index) {
                  final order = orderState.orders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderEntity order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(orderId: order.id!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),

              // order date
              Text(
                'Placed on ${_formatDate(order.createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),

              // items count
              Text(
                '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),

              // total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text('Rs. ${order.total.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        ),
      ),
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
}

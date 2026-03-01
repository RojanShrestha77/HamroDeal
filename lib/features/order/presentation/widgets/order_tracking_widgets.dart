import 'package:flutter/material.dart';

class OrderTrackingWidget extends StatelessWidget {
  final String orderStatus; // 'pending', 'processing', 'shipped', 'delivered'
  final DateTime? orderPlacedDate;
  final DateTime? orderPackedDate;
  final DateTime? assignedToLogisticsDate;
  final DateTime? outForDeliveryDate;
  final DateTime? deliveredDate;

  const OrderTrackingWidget({
    Key? key,
    required this.orderStatus,
    this.orderPlacedDate,
    this.orderPackedDate,
    this.assignedToLogisticsDate,
    this.outForDeliveryDate,
    this.deliveredDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Your Order',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          _buildTrackingStep(
            icon: Icons.settings_outlined,
            title: 'Order Placed',
            date: orderPlacedDate,
            isCompleted: true,
            isActive: orderStatus == 'pending',
            showLine: true,
          ),
          _buildTrackingStep(
            icon: Icons.inventory_2_outlined,
            title: 'Order Packed',
            date: orderPackedDate,
            isCompleted: _isStepCompleted('processing'),
            isActive: orderStatus == 'processing',
            showLine: true,
          ),
          _buildTrackingStep(
            icon: Icons.person_outline,
            title: 'Assigned to logistics',
            date: assignedToLogisticsDate,
            isCompleted: _isStepCompleted('shipped'),
            isActive: orderStatus == 'shipped',
            showLine: true,
          ),
          _buildTrackingStep(
            icon: Icons.check_circle_outline,
            title: 'Out for Delivery',
            date: outForDeliveryDate,
            isCompleted: _isStepCompleted('delivered'),
            isActive: orderStatus == 'delivered',
            showLine: true,
          ),
          _buildTrackingStep(
            icon: Icons.check_circle_outline,
            title: 'Order Delivered',
            date: deliveredDate,
            isCompleted: orderStatus == 'delivered',
            isActive: false,
            showLine: false,
          ),
        ],
      ),
    );
  }

  bool _isStepCompleted(String stepStatus) {
    const statusOrder = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = statusOrder.indexOf(orderStatus);
    final stepIndex = statusOrder.indexOf(stepStatus);
    return currentIndex >= stepIndex;
  }

  Widget _buildTrackingStep({
    required IconData icon,
    required String title,
    required DateTime? date,
    required bool isCompleted,
    required bool isActive,
    required bool showLine,
  }) {
    final stepColor = isCompleted || isActive
        ? const Color(0xFF7C3AED) // Purple color
        : Colors.grey[300]!;

    final textColor = isCompleted || isActive
        ? Colors.black
        : Colors.grey[400]!;
    final dateColor = isCompleted || isActive
        ? Colors.black
        : Colors.grey[300]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Icon and line
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted || isActive
                    ? const Color(0xFFEC4899)
                    : Colors.grey[300],
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [stepColor, stepColor.withOpacity(0.3)],
                  ),
                ),
                child: CustomPaint(
                  painter: DottedLinePainter(color: stepColor, dotSpacing: 4),
                ),
              ),
          ],
        ),
        const SizedBox(width: 20),
        // Right side - Icon, title, and date
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: stepColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: stepColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                if (date != null)
                  Text(
                    _formatDate(date),
                    style: TextStyle(fontSize: 14, color: dateColor),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$month $day, $year $hour:$minute';
  }
}

// Custom painter for dotted line
class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSpacing;

  DottedLinePainter({required this.color, this.dotSpacing = 4});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + 3),
        paint,
      );
      startY += dotSpacing + 3;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

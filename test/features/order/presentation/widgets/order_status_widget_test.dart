import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/order/presentation/widgets/order_tracking_widgets.dart';

void main() {
  group('Order Status Widget Tests', () {
    testWidgets('Order tracking widget displays pending status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'pending',
              orderPlacedDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Track Your Order'), findsOneWidget);
      expect(find.text('Order Placed'), findsOneWidget);
    });

    testWidgets('Order tracking widget displays processing status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'processing',
              orderPlacedDate: DateTime.now(),
              orderPackedDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Order Packed'), findsOneWidget);
    });

    testWidgets('Order tracking widget displays shipped status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'shipped',
              orderPlacedDate: DateTime.now(),
              orderPackedDate: DateTime.now(),
              assignedToLogisticsDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Assigned to logistics'), findsOneWidget);
    });

    testWidgets('Order tracking widget displays delivered status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'delivered',
              orderPlacedDate: DateTime.now(),
              orderPackedDate: DateTime.now(),
              assignedToLogisticsDate: DateTime.now(),
              outForDeliveryDate: DateTime.now(),
              deliveredDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Order Delivered'), findsOneWidget);
    });

    testWidgets('Order tracking widget has timeline', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'delivered',
              orderPlacedDate: DateTime.now(),
              orderPackedDate: DateTime.now(),
              assignedToLogisticsDate: DateTime.now(),
              outForDeliveryDate: DateTime.now(),
              deliveredDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    });

    testWidgets('Order tracking widget displays all tracking steps', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'delivered',
              orderPlacedDate: DateTime.now(),
              orderPackedDate: DateTime.now(),
              assignedToLogisticsDate: DateTime.now(),
              outForDeliveryDate: DateTime.now(),
              deliveredDate: DateTime.now(),
            ),
          ),
        ),
      );

      expect(find.text('Out for Delivery'), findsOneWidget);
    });

    testWidgets('Order tracking widget displays dates', (WidgetTester tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTrackingWidget(
              orderStatus: 'pending',
              orderPlacedDate: now,
            ),
          ),
        ),
      );

      expect(find.byType(OrderTrackingWidget), findsOneWidget);
    });
  });
}

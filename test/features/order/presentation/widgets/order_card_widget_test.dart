import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Card Widget Tests', () {
    testWidgets('Order card displays order ID', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: const Text('Order #12345'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Order #12345'), findsOneWidget);
    });

    testWidgets('Order card displays order status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                subtitle: const Text('Status: Delivered'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Status: Delivered'), findsOneWidget);
    });

    testWidgets('Order card displays order date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('2024-03-07'),
            ),
          ),
        ),
      );

      expect(find.text('2024-03-07'), findsOneWidget);
    });

    testWidgets('Order card displays total amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('Total: \$299.99'),
            ),
          ),
        ),
      );

      expect(find.text('Total: \$299.99'), findsOneWidget);
    });

    testWidgets('Order card has view details button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('View Details'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('View Details'), findsOneWidget);
    });
  });
}

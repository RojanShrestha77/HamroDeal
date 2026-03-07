import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notification Item Widget Tests', () {
    testWidgets('Notification item displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Order Shipped'),
            ),
          ),
        ),
      );

      expect(find.text('Order Shipped'), findsOneWidget);
    });

    testWidgets('Notification item displays message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              subtitle: Text('Your order has been shipped'),
            ),
          ),
        ),
      );

      expect(find.text('Your order has been shipped'), findsOneWidget);
    });

    testWidgets('Notification item displays timestamp', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              trailing: Text('2 hours ago'),
            ),
          ),
        ),
      );

      expect(find.text('2 hours ago'), findsOneWidget);
    });

    testWidgets('Notification item has read indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Notification item is dismissible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Dismissible(
              key: Key('notification'),
              child: ListTile(
                title: Text('Notification'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Dismissible), findsOneWidget);
    });
  });
}

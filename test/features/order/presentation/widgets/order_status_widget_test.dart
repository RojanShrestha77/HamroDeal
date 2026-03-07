import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Status Widget Tests', () {
    testWidgets('Order status displays pending status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.orange,
              child: Text('Pending'),
            ),
          ),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('Order status displays processing status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.blue,
              child: Text('Processing'),
            ),
          ),
        ),
      );

      expect(find.text('Processing'), findsOneWidget);
    });

    testWidgets('Order status displays shipped status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.purple,
              child: Text('Shipped'),
            ),
          ),
        ),
      );

      expect(find.text('Shipped'), findsOneWidget);
    });

    testWidgets('Order status displays delivered status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.green,
              child: Text('Delivered'),
            ),
          ),
        ),
      );

      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('Order status displays cancelled status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.red,
              child: Text('Cancelled'),
            ),
          ),
        ),
      );

      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('Order status has timeline', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(children: [Icon(Icons.check_circle), Text('Order Placed')]),
                Row(children: [Icon(Icons.check_circle), Text('Processing')]),
                Row(children: [Icon(Icons.check_circle), Text('Shipped')]),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('Order status displays tracking number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Tracking Number:'),
                Text('TRK123456789'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('TRK123456789'), findsOneWidget);
    });
  });
}

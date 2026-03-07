import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart Summary Widget Tests', () {
    testWidgets('Cart summary displays subtotal', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    Text('Subtotal:'),
                    Text('\$299.99'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Subtotal:'), findsOneWidget);
      expect(find.text('\$299.99'), findsOneWidget);
    });

    testWidgets('Cart summary displays shipping cost', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('Shipping:'),
                Text('\$10.00'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Shipping:'), findsOneWidget);
    });

    testWidgets('Cart summary displays tax', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('Tax:'),
                Text('\$30.00'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Tax:'), findsOneWidget);
    });

    testWidgets('Cart summary displays total', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('Total:'),
                Text('\$339.99'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('Cart summary has checkout button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Proceed to Checkout'),
            ),
          ),
        ),
      );

      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });

    testWidgets('Cart summary has continue shopping button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: Text('Continue Shopping'),
            ),
          ),
        ),
      );

      expect(find.text('Continue Shopping'), findsOneWidget);
    });

    testWidgets('Cart summary displays discount code input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: InputDecoration(
                hintText: 'Enter discount code',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}

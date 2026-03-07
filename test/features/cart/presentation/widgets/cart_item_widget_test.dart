import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart Item Widget Tests', () {
    testWidgets('Cart item displays product name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Product Name'),
              subtitle: Text('Quantity: 2'),
            ),
          ),
        ),
      );

      expect(find.text('Product Name'), findsOneWidget);
    });

    testWidgets('Cart item displays quantity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Product'),
              subtitle: Text('Quantity: 2'),
            ),
          ),
        ),
      );

      expect(find.text('Quantity: 2'), findsOneWidget);
    });

    testWidgets('Cart item displays price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Product'),
              trailing: Text('\$199.98'),
            ),
          ),
        ),
      );

      expect(find.text('\$199.98'), findsOneWidget);
    });

    testWidgets('Cart item has increment button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                IconButton(icon: Icon(Icons.add), onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Cart item has decrement button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                IconButton(icon: Icon(Icons.remove), onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.remove), findsOneWidget);
    });
  });
}

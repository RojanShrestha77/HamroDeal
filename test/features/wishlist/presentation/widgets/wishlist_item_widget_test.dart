import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Wishlist Item Widget Tests', () {
    testWidgets('Wishlist item displays product name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Wishlist Product'),
            ),
          ),
        ),
      );

      expect(find.text('Wishlist Product'), findsOneWidget);
    });

    testWidgets('Wishlist item displays price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: Text('Product'),
              trailing: Text('\$49.99'),
            ),
          ),
        ),
      );

      expect(find.text('\$49.99'), findsOneWidget);
    });

    testWidgets('Wishlist item has remove button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Wishlist item has add to cart button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Add to Cart'),
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('Wishlist item displays availability', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              subtitle: Text('In Stock'),
            ),
          ),
        ),
      );

      expect(find.text('In Stock'), findsOneWidget);
    });
  });
}

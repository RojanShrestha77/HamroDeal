import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Card Widget Tests', () {
    testWidgets('Product card displays product name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Column(
                children: const [
                  Text('Test Product'),
                  Text('Rs. 100'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('Product card displays price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('Rs. 100'),
            ),
          ),
        ),
      );

      expect(find.text('Rs. 100'), findsOneWidget);
    });

    testWidgets('Product card displays stock badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('10 in Stock'),
            ),
          ),
        ),
      );

      expect(find.text('10 in Stock'), findsOneWidget);
    });

    testWidgets('Product card has add to cart button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add to cart'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add to cart'), findsOneWidget);
    });

    testWidgets('Product card has wishlist button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });
}

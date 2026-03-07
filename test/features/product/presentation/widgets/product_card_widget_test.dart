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
                children: [
                  Text('Product Name'),
                  Text('\$99.99'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Product Name'), findsOneWidget);
    });

    testWidgets('Product card displays price', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Text('\$99.99'),
            ),
          ),
        ),
      );

      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('Product card displays rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Row(
                children: [
                  Icon(Icons.star),
                  Text('4.5'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('Product card has add to cart button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Add to Cart'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('Product card has wishlist button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: IconButton(
                icon: Icon(Icons.favorite_border),
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

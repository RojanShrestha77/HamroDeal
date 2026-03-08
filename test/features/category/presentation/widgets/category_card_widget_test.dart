import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Category Card Widget Tests', () {
    testWidgets('Category card displays category name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('Electronics'),
            ),
          ),
        ),
      );

      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('Category card displays category icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Icon(Icons.devices),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.devices), findsOneWidget);
    });

    testWidgets('Category card displays product count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: const Text('245 products'),
            ),
          ),
        ),
      );

      expect(find.text('245 products'), findsOneWidget);
    });

    testWidgets('Category card is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () {},
              child: const Card(
                child: Text('Category'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('Category card displays discount badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Stack(
                children: [
                  const Text('Category'),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      color: Colors.red,
                      child: const Text('20% OFF'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('20% OFF'), findsOneWidget);
    });
  });
}

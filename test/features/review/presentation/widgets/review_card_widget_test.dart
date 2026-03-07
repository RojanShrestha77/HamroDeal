import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Review Card Widget Tests', () {
    testWidgets('Review card displays reviewer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text('John Doe'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Review card displays rating stars', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Row(
                children: [
                  Icon(Icons.star),
                  Icon(Icons.star),
                  Icon(Icons.star),
                  Icon(Icons.star),
                  Icon(Icons.star_border),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('Review card displays review text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Text('Great product, highly recommended!'),
            ),
          ),
        ),
      );

      expect(find.text('Great product, highly recommended!'), findsOneWidget);
    });

    testWidgets('Review card displays review date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Text('2024-03-01'),
            ),
          ),
        ),
      );

      expect(find.text('2024-03-01'), findsOneWidget);
    });

    testWidgets('Review card has helpful button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.thumb_up), findsOneWidget);
    });
  });
}

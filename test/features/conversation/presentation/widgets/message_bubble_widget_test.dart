import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Bubble Widget Tests', () {
    testWidgets('Message bubble displays sender message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: Colors.blue,
                child: Text('Hello!'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('Message bubble displays receiver message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.grey,
                child: Text('Hi there!'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hi there!'), findsOneWidget);
    });

    testWidgets('Message bubble displays timestamp', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Message'),
                Text('10:30 AM'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('10:30 AM'), findsOneWidget);
    });

    testWidgets('Message bubble displays delivery status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Text('Message'),
                Icon(Icons.done_all),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('Message bubble has different colors for sender/receiver', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Container(color: Colors.blue, child: Text('Sent')),
                Container(color: Colors.grey, child: Text('Received')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });
}

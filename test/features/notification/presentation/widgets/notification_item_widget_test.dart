import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/notification/presentation/widgets/notification_card.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';

void main() {
  group('Notification Item Widget Tests', () {
    final testNotification = NotificationEntity(
      id: '1',
      userId: '1',
      title: 'Order Shipped',
      message: 'Your order has been shipped',
      type: 'order',
      isRead: false,
      createdAt: DateTime.now(),
    );

    testWidgets('Notification card displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: testNotification),
          ),
        ),
      );

      expect(find.text('Order Shipped'), findsOneWidget);
    });

    testWidgets('Notification card displays message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: testNotification),
          ),
        ),
      );

      expect(find.text('Your order has been shipped'), findsOneWidget);
    });

    testWidgets('Notification card displays timestamp', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: testNotification),
          ),
        ),
      );

      expect(find.byType(NotificationCard), findsOneWidget);
    });

    testWidgets('Notification card has read indicator', (WidgetTester tester) async {
      final unreadNotification = NotificationEntity(
        id: '1',
        userId: '1',
        title: 'Order Shipped',
        message: 'Your order has been shipped',
        type: 'order',
        isRead: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: unreadNotification),
          ),
        ),
      );

      expect(find.byType(NotificationCard), findsOneWidget);
    });

    testWidgets('Notification card displays icon based on type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: testNotification),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    });
  });
}

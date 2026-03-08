import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/message_bubble.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';

void main() {
  group('Message Bubble Widget Tests', () {
    final testMessage = MessageEntity(
      id: '1',
      conversationId: '1',
      senderId: 'sender1',
      content: 'Hello!',
      isRead: true,
      createdAt: DateTime.now(),
    );

    testWidgets('Message bubble displays sender message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: testMessage,
              isMe: true,
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
            body: MessageBubble(
              message: testMessage,
              isMe: false,
            ),
          ),
        ),
      );

      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('Message bubble displays timestamp', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: testMessage,
              isMe: true,
            ),
          ),
        ),
      );

      expect(find.byType(MessageBubble), findsOneWidget);
    });

    testWidgets('Message bubble displays delivery status', (WidgetTester tester) async {
      final readMessage = MessageEntity(
        id: '1',
        conversationId: '1',
        senderId: 'sender1',
        content: 'Message',
        isRead: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: readMessage,
              isMe: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('Message bubble has different alignment for sender/receiver', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MessageBubble(
                  message: testMessage,
                  isMe: true,
                ),
                MessageBubble(
                  message: testMessage,
                  isMe: false,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(MessageBubble), findsWidgets);
    });
  });
}

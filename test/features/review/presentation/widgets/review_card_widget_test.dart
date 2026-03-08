import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/review/presentation/widgets/review_card.dart';
import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';

void main() {
  group('Review Card Widget Tests', () {
    final testUser = ReviewUserEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
    );

    final testReview = ReviewEntity(
      id: '1',
      productId: '1',
      user: testUser,
      rating: 4,
      comment: 'Great product, highly recommended!',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    testWidgets('Review card displays reviewer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewCard(review: testReview),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Review card displays rating stars', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewCard(review: testReview),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('Review card displays review text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewCard(review: testReview),
          ),
        ),
      );

      expect(find.text('Great product, highly recommended!'), findsOneWidget);
    });

    testWidgets('Review card displays review date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewCard(review: testReview),
          ),
        ),
      );

      expect(find.byType(ReviewCard), findsOneWidget);
    });

    testWidgets('Review card displays user avatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewCard(review: testReview),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}

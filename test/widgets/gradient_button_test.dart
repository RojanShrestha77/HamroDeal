import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/core/widgets/gradient_button.dart';

void main() {
  testWidgets('GradientButton displays the correct text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradientButton(text: 'Save', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('GradientButton shows loading indicator when isLoading is true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradientButton(
            text: 'Loading...',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsNothing);
  });

  testWidgets('GradientButton calls onPressed when tapped', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradientButton(
            text: 'Submit',
            onPressed: () => wasPressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(wasPressed, true);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/widgets/my_button.dart';

void main() {
  testWidgets('MyButton displays the correct text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(text: 'Click Me', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
  });

  testWidgets('MyButton calls onPressed when tapped', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(text: 'Submit', onPressed: () => wasPressed = true),
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(wasPressed, true);
  });
}

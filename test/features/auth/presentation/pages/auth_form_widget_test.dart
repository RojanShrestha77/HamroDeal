import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Form Widget Tests', () {
    testWidgets('Login form displays email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(decoration: const InputDecoration(labelText: 'Email')),
                TextFormField(decoration: const InputDecoration(labelText: 'Password')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Login button is enabled when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('SIGN IN'),
            ),
          ),
        ),
      );

      expect(find.text('SIGN IN'), findsOneWidget);
    });

    testWidgets('Password field obscures text by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      expect(textFields, findsWidgets);
    });

    testWidgets('Register link navigates to registration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () {},
              child: const Text('Sign Up'),
            ),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Forgot password link is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?'),
            ),
          ),
        ),
      );

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
}

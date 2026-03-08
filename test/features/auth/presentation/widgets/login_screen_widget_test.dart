import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Screen Widget Tests', () {
    testWidgets('Login screen displays welcome header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                Text('Welcome Back'),
                Text('Enter your credentials to continue'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Login screen displays subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Enter your credentials to continue'),
          ),
        ),
      );

      expect(find.text('Enter your credentials to continue'), findsOneWidget);
    });

    testWidgets('Login screen has email input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('Login screen has password input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('Login screen has forgot password link', (WidgetTester tester) async {
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

    testWidgets('Login screen has sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: const Text('Sign Up'),
            ),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Login screen has social login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Google'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Apple'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('Login screen displays sign in button', (WidgetTester tester) async {
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
  });
}

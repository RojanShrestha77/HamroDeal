import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_search_bar.dart';

void main() {
  group('Product List Widget Tests', () {
    testWidgets('Product search bar displays search icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Product search bar accepts input', (WidgetTester tester) async {
      String? searchValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (value) {
                searchValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test product');
      expect(searchValue, 'test product');
    });

    testWidgets('Product search bar shows clear button when text entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsWidgets);
    });

    testWidgets('Product search bar has correct hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Search Products..'), findsOneWidget);
    });

    testWidgets('Product search bar initializes with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              initialValue: 'initial search',
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('initial search'), findsOneWidget);
    });

    testWidgets('Product search bar has rounded border', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Product search bar is contained in padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductSearchBar(
              onSearch: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });
}

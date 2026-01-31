import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/core/error/failures.dart';

void main() {
  group('ApiFailure test', () {
    test('has correct message', () {
      const failure = ApiFailure(message: 'Network error');
      String expectedValue = 'Network error';

      String actualValue = failure.message;

      expect(expectedValue, actualValue);
    });

    test('has statusCode when provided', () {
      const failure = ApiFailure(message: 'Not found', statusCode: 404);
      int expectedCode = 404;

      int? actualCode = failure.statusCode;

      expect(expectedCode, actualCode);
    });
  });

  group('LocalDatabaseFailure test', () {
    test('has default message', () {
      const failure = LocalDatabaseFailure();
      String expectedValue = 'Local database operation failed';

      String actualValue = failure.message;

      expect(expectedValue, actualValue);
    });

    test('has custom message when provided', () {
      const failure = LocalDatabaseFailure(message: 'Hive failed');
      String expectedValue = 'Hive failed';

      String actualValue = failure.message;

      expect(expectedValue, actualValue);
    });
  });
}

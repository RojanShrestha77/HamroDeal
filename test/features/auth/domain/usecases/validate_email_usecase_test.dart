import 'package:flutter_test/flutter_test.dart';

class ValidateEmailUseCase {
  bool call(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}

void main() {
  group('ValidateEmailUseCase', () {
    late ValidateEmailUseCase useCase;

    setUp(() {
      useCase = ValidateEmailUseCase();
    });

    test('returns true for valid email', () {
      expect(useCase('user@example.com'), true);
    });

    test('returns false for email without @', () {
      expect(useCase('userexample.com'), false);
    });

    test('returns false for email without domain', () {
      expect(useCase('user@'), false);
    });

    test('returns false for empty email', () {
      expect(useCase(''), false);
    });

    test('returns true for valid email with numbers', () {
      expect(useCase('user123@example.com'), true);
    });
  });
}

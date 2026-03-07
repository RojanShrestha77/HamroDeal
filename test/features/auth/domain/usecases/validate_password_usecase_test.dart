import 'package:flutter_test/flutter_test.dart';

class ValidatePasswordUseCase {
  bool call(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
}

void main() {
  group('ValidatePasswordUseCase', () {
    late ValidatePasswordUseCase useCase;

    setUp(() {
      useCase = ValidatePasswordUseCase();
    });

    test('returns true for valid password', () {
      expect(useCase('Password123'), true);
    });

    test('returns false for password less than 8 characters', () {
      expect(useCase('Pass12'), false);
    });

    test('returns false for password without uppercase', () {
      expect(useCase('password123'), false);
    });

    test('returns false for password without numbers', () {
      expect(useCase('Password'), false);
    });

    test('returns true for valid strong password', () {
      expect(useCase('SecurePass123'), true);
    });
  });
}

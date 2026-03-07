import 'package:flutter_test/flutter_test.dart';

class ValidateUsernameUseCase {
  bool call(String username) {
    return username.isNotEmpty &&
        username.length >= 3 &&
        username.length <= 20 &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }
}

void main() {
  group('ValidateUsernameUseCase', () {
    late ValidateUsernameUseCase useCase;

    setUp(() {
      useCase = ValidateUsernameUseCase();
    });

    test('returns true for valid username', () {
      expect(useCase('john_doe'), true);
    });

    test('returns false for username less than 3 characters', () {
      expect(useCase('ab'), false);
    });

    test('returns false for username more than 20 characters', () {
      expect(useCase('a' * 21), false);
    });

    test('returns false for username with special characters', () {
      expect(useCase('john@doe'), false);
    });

    test('returns true for username with numbers', () {
      expect(useCase('john123'), true);
    });
  });
}

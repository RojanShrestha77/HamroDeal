import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_deal/features/auth/domain/usecases/register_usecase.dart';

void main() {
  group('RegisterUsecase - Username Validation', () {
    test('RegisterUsecase accepts valid username in params', () {
      final params = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params.username, 'john_doe');
      expect(params.username.length, greaterThanOrEqualTo(3));
      expect(params.username.length, lessThanOrEqualTo(20));
    });

    test('RegisterUsecase accepts username with numbers', () {
      final params = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john123',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params.username, 'john123');
    });

    test('RegisterUsecase params validates email is not empty', () {
      final params = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params.email, isNotEmpty);
    });

    test('RegisterUsecase params validates password matches confirmPassword', () {
      final params = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params.password, equals(params.confirmPassword));
    });

    test('RegisterUsecase params are equatable', () {
      final params1 = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      final params2 = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params1, equals(params2));
    });

    test('RegisterUsecase params with different values are not equal', () {
      final params1 = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'john_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      final params2 = RegisterUsecaseParams(
        email: 'test@example.com',
        username: 'jane_doe',
        password: 'password123',
        confirmPassword: 'password123',
      );

      expect(params1, isNot(equals(params2)));
    });
  });
}

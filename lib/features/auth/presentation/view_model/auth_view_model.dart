import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/auth/domain/usecases/login_usecase.dart';
import 'package:hamro_deal/features/auth/domain/usecases/register_usecase.dart';
import 'package:hamro_deal/features/auth/presentation/state/auth_state.dart';

// provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    String? profileImage,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    // wait for 2 seconds to simulate network call
    // await Future.delayed(const Duration(seconds: 2));

    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      username: username,
      password: password,
      profileImage: profileImage,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration failed',
        );
      },
      (isRegistered) {
        state = state.copyWith(
          status: AuthStatus.registered,
          errorMessage: null,
        );
      },
    );
  }

  // login
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(username: username, password: password);

    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
          errorMessage: null,
        );
      },
    );
  }
}

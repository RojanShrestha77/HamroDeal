import 'package:flutter_riverpod/legacy.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final AuthEntity? currentUser;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.currentUser,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    AuthEntity? currentUser,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _authRepository;

  AuthController(this._authRepository) : super(AuthState());

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.login(email, password);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: 'Invalid credentials',
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          currentUser: user,
          errorMessage: null,
        );
      },
    );
  }

  // Register
  Future<void> register(AuthEntity user) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.register(user);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Registration failed',
        );
      },
      (success) {
        if (success) {
          state = state.copyWith(isLoading: false, errorMessage: null);
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Email already exists',
          );
        }
      },
    );
  }

  // Logout
  Future<void> logout() async {
    final result = await _authRepository.logout();
    result.fold((failure) {}, (success) {
      state = AuthState(
        isLoading: false,
        isAuthenticated: false,
        currentUser: null,
        errorMessage: null,
      );
    });
  }

  // Get current user
  Future<void> getCurrentUser() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        state = state.copyWith(isAuthenticated: false);
      },
      (user) {
        if (user != null) {
          state = state.copyWith(isAuthenticated: true, currentUser: user);
        }
      },
    );
  }
}

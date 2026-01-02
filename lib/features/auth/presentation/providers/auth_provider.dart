import 'package:flutter_riverpod/legacy.dart';
import 'package:hamro_deal/features/auth/presentation/controller/auth_controller.dart';
import 'package:hamro_deal/features/auth/data/repositories/auth_repository_impl.dart';

// Provider for AuthController
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(authRepository as AuthRepositoryImpl);
  },
);

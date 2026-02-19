import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/auth/domain/usecases/login_usecase.dart';
import 'package:hamro_deal/features/auth/domain/usecases/register_usecase.dart';
import 'package:hamro_deal/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:hamro_deal/features/auth/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:hamro_deal/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final UploadProfilePictureUsecase _uploadProfilePictureUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _uploadProfilePictureUsecase = ref.read(
      uploadProfilePictureUsecaseProvider,
    );
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    return AuthState();
  }

  Future<void> register({
    String? firstName,
    String? lastName,
    required String email,
    required String username,
    required String password,
    required String confirmPassword, // ← Added this parameter
    String? imageUrl,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword, // ← Added this
      imageUrl: imageUrl,
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

  Future<String?> uploadProfilePicture(File photo) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _uploadProfilePictureUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadedProfilePictureUrl: url,
        );
        return url;
      },
    );
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = UpdateProfileUsecaseParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );

    final result = await _updateProfileUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (updatedUser) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: updatedUser,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  void clearUploadedProfilePicture() {
    state = state.copyWith(
      uploadedProfilePictureUrl: null,
      resetUploadedProfilePictureUrl: true,
    );
  }
}

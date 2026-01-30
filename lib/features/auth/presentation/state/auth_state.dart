import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  intial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
  loaded,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? authEntity;
  final String? errorMessage;
  final String? uploadedProfilePictureUrl;

  const AuthState({
    this.status = AuthStatus.intial,
    this.authEntity,
    this.errorMessage,
    this.uploadedProfilePictureUrl,
  });

  // copyWith
  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? errorMessage,
    String? uploadedProfilePictureUrl,
    bool resetErrorMessage = false,
    bool resetUploadedProfilePictureUrl = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedProfilePictureUrl: resetUploadedProfilePictureUrl
          ? null
          : (uploadedProfilePictureUrl ?? this.uploadedProfilePictureUrl),
    );
  }

  @override
  List<Object?> get props => [
    status,
    authEntity,
    errorMessage,
    uploadedProfilePictureUrl,
  ];
}

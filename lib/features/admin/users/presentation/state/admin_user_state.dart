import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

enum AdminUserViewStatus {
  intial,
  loading,
  loaded,
  userUpdated,
  userDeleted,
  sellerApprroved,
  error,
}

class AdminUserState extends Equatable {
  final AdminUserViewStatus status;
  final List<AuthEntity> users;
  final AuthEntity? currentUser;
  final String? errorMessage;

  const AdminUserState({
    this.status = AdminUserViewStatus.intial,
    this.users = const [],
    this.currentUser,
    this.errorMessage,
  });

  AdminUserState copyWith({
    AdminUserViewStatus? status,
    List<AuthEntity>? users,
    AuthEntity? currentUser,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return AdminUserState(
      status: status ?? this.status,
      users: users ?? this.users,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, users, currentUser, errorMessage];
}

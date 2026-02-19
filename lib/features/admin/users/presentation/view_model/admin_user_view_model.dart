import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/admin/users/domain/usecases/approve_seller_usecase.dart';
import 'package:hamro_deal/features/admin/users/domain/usecases/delete_user_usecase.dart';
import 'package:hamro_deal/features/admin/users/domain/usecases/get_all_users_usecase.dart';
import 'package:hamro_deal/features/admin/users/domain/usecases/update_user_usecase.dart';
import 'package:hamro_deal/features/admin/users/presentation/state/admin_user_state.dart';
import 'package:hamro_deal/features/category/domain/usecases/get_all_categories_usecase.dart';

final adminUserViewModelProvider =
    NotifierProvider<AdminUserViewModel, AdminUserState>(
      () => AdminUserViewModel(),
    );

class AdminUserViewModel extends Notifier<AdminUserState> {
  late final GetAllUsersUsecase _getAllUsersUsecase;
  late final UpdateUserUsecase _updateUserUsecase;
  late final DeleteUserUsecase _deleteUserUsecase;
  late final ApproveSellerUsecase _approveSellerUsecase;

  @override
  AdminUserState build() {
    _getAllUsersUsecase = ref.watch(getAllUsersUsecaseProvider);
    _updateUserUsecase = ref.watch(updateUserUsecaseProvider);
    _deleteUserUsecase = ref.watch(deleteUserUsecaseProvider);
    _approveSellerUsecase = ref.watch(approveSellerUsecaseProvider);
    return const AdminUserState();
  }

  // get allusers
  Future<void> getAllUsers() async {
    state = state.copyWith(
      status: AdminUserViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _getAllUsersUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminUserViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (users) {
        state = state.copyWith(
          status: AdminUserViewStatus.loaded,
          users: users,
          resetErrorMessage: true,
        );
      },
    );
  }

  // update user
  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    state = state.copyWith(
      status: AdminUserViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _updateUserUsecase(userId, data);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminUserViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (updatedUser) {
        final updatedUsers = state.users.map((user) {
          return user.userId == userId ? updatedUser : user;
        }).toList();

        state = state.copyWith(
          status: AdminUserViewStatus.userUpdated,
          users: updatedUsers,
          currentUser: updatedUser,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // delete user
  Future<bool> deleteUser(String userId) async {
    state = state.copyWith(
      status: AdminUserViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _deleteUserUsecase(userId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminUserViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final updatedUsers = state.users
            .where((user) => user.userId != userId)
            .toList();

        state = state.copyWith(
          status: AdminUserViewStatus.userDeleted,
          users: updatedUsers,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  // aporove seller
  Future<bool> approveSeller(String userId) async {
    state = state.copyWith(
      status: AdminUserViewStatus.loading,
      resetErrorMessage: true,
    );

    final result = await _approveSellerUsecase(userId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminUserViewStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (approvedUser) {
        final updatedUsers = state.users.map((user) {
          return user.userId == userId ? approvedUser : user;
        }).toList();
        state = state.copyWith(
          status: AdminUserViewStatus.sellerApprroved,
          users: updatedUsers,
          currentUser: approvedUser,
          resetErrorMessage: true,
        );
        return true;
      },
    );
  }

  void resetError() {
    state = state.copyWith(resetErrorMessage: true);
  }
}

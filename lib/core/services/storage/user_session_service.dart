import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    "Shared prefs lai hamile main.dart ma implement garxau and tmi dhukka basnnus hai",
  );
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(SharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = "user_email";
  static const String _keyUsername = 'username';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserBatchId = 'user_batch_id';
  static const String _keyUserProfileImage = 'user_profile_image';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserIsApproved = 'user_is_approved';

  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String username,
    required String fullName,
    String? phoneNumber,
    String? batchId,
    String? profileImage,
    String? role,
    bool? isApproved,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUsername, username);
    await _prefs.setString(_keyUserFullName, fullName);

    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    if (batchId != null) {
      await _prefs.setString(_keyUserBatchId, batchId);
    }
    if (profileImage != null) {
      await _prefs.setString(_keyUserProfileImage, profileImage);
    }
    if (role != null) {
      await _prefs.setString(_keyUserRole, role);
    }
    if (isApproved != null) {
      await _prefs.setBool(_keyUserIsApproved, isApproved);
    }
  }

  Future<void> clearUserSession() async {
    await _prefs.remove(_keyUserBatchId);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserProfileImage);
    await _prefs.remove(_keyUserRole);
    await _prefs.remove(_keyUserIsApproved);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getUsername() {
    return _prefs.getString(_keyUsername);
  }

  String? getUserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  String? getUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  String? getUserBatchId() {
    return _prefs.getString(_keyUserBatchId);
  }

  String? getUserProfileImage() {
    return _prefs.getString(_keyUserProfileImage);
  }

  String? getUserRole() {
    return _prefs.getString(_keyUserRole);
  }

  bool? getUserIsApproved() {
    return _prefs.getBool(_keyUserIsApproved);
  }
}

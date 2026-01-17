import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// shared prefs provider
final SharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  // SharedPreferences.getInstance();
  throw UnimplementedError(
    "Shared prefs lai hamile main.dart ma inmplement garxau and tmi dhukka basnnus hai",
  );

  // here the provider doesnot allows to perform the asynchronous work
  // so we implement it in the main.dart
  // async
  // sync
});
// Provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(SharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // kerys for storing data
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = "user_email";
  static const String _keyUsername = 'username';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserPhoneNumber = 'user_batch_id';
  static const String _keyUserBatchId = 'user_batch_id';
  static const String _keyUserProfileImage = 'user_profile_image';

  // Store user session data
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String username,
    required String fullName,
    String? phoneNumber,
    String? batchId,
    String? profileImage,
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
  }

  // clear User session data
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyUserBatchId);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserProfileImage);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getUserId() {
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
}

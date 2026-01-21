import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  final prefs = ref.read(SharedPreferencesProvider);
  return TokenService(prefs: prefs);
});

class TokenService {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenService({required SharedPreferences prefs}) : _prefs = prefs;

  // save token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  //  get token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  // remove token
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}

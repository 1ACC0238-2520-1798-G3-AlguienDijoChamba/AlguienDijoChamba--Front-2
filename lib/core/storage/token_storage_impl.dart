// Archivo: lib/core/storage/token_storage_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'token_storage.dart';

class TokenStorageImpl implements TokenStorage {
  static const _tokenKey = 'auth_token';

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
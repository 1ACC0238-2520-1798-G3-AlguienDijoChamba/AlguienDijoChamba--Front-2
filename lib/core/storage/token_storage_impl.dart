// Archivo: lib/core/storage/token_storage_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'token_storage.dart';

/// Implementación de TokenStorage usando SharedPreferences
/// para almacenar tokens y datos del usuario de forma persistente.
class TokenStorageImpl implements TokenStorage {
  // Claves para SharedPreferences
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _customerIdKey = 'customer_id';

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('✅ Token guardado en SharedPreferences');
  }

  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('✅ Token eliminado de SharedPreferences');
  }

  @override
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  @override
  Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
    print('✅ UserId guardado: $id');
  }

  @override
  Future<void> deleteUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    print('✅ UserId eliminado de SharedPreferences');
  }

  @override
  Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerIdKey);
  }

  @override
  Future<void> saveCustomerId(String customerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerIdKey, customerId);
    print('✅ CustomerId guardado: $customerId');
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_customerIdKey);
    print('✅ Todos los datos de autenticación eliminados (Logout)');
  }
}

// Archivo: lib/core/storage/token_storage.dart

abstract class TokenStorage {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<String?> getUserId();
  Future<void> saveUserId(String id);
  Future<void> deleteUserId();
}


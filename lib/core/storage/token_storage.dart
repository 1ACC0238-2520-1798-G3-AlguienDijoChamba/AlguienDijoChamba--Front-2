// Archivo: lib/core/storage/token_storage.dart

/// Interface para almacenar y recuperar tokens de autenticación
/// y datos del usuario de forma segura.
abstract class TokenStorage {
  /// Guarda el token JWT después del login
  Future<void> saveToken(String token);

  /// Obtiene el token JWT guardado
  Future<String?> getToken();

  /// Elimina el token (logout)
  Future<void> deleteToken();

  /// Guarda el ID del usuario (userId) después del login
  Future<void> saveUserId(String id);

  /// Obtiene el ID del usuario guardado
  Future<String?> getUserId();

  /// Elimina el ID del usuario
  Future<void> deleteUserId();

  /// Guarda el ID del cliente (customerId) después del login
  Future<void> saveCustomerId(String customerId);

  /// Obtiene el ID del cliente guardado
  Future<String?> getCustomerId();

  /// Limpia todos los datos guardados (logout)
  Future<void> clearAll();
}

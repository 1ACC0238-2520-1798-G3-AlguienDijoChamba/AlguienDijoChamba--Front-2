// lib/core/errors/exceptions.dart

abstract class AppException implements Exception {
  final String message;
  const AppException({required this.message});
}

// Excepción lanzada cuando hay un error del lado del servidor (e.g., status 400-599)
class ServerException extends AppException {
  const ServerException({required super.message});
}

// Excepción lanzada cuando hay un error de caché o almacenamiento local
class CacheException extends AppException {
  const CacheException({required super.message});
}

// Excepción lanzada cuando la respuesta JSON es inválida o faltan campos
class FormatException extends AppException {
  const FormatException({required super.message});
}

// Excepción lanzada por problemas de red
class ConnectionException extends AppException {
  const ConnectionException({required super.message});
}
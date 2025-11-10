// lib/core/errors/failures.dart

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Fallo que ocurre cuando el servidor devuelve un error conocido (4xx o 5xx)
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

// Fallo que ocurre cuando hay problemas de red (ej. sin conexión)
class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

// Fallo que ocurre cuando el token no es válido o está ausente (401)
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

// Fallo para cualquier error no esperado o atrapado (catch-all)
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
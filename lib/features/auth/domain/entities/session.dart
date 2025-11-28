import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class Session {
  final String token;
  final DateTime? expiration;
  final User user;

  Session({
    required this.token,
    required this.user,
    this.expiration,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 SESSION.fromJson: Raw JSON keys: ${json.keys.toList()}');
    debugPrint('🔍 SESSION.fromJson: Full JSON: $json');

    // ✅ PRIORIDAD 1: Buscar 'userId' (nuevo backend)
    String? userId = json['userId'] as String?;
    
    // ✅ PRIORIDAD 2: Buscar 'customerId' (retrocompatibilidad)
    if (userId == null || userId.isEmpty) {
      userId = json['customerId'] as String?;
      debugPrint('⚠️ SESSION.fromJson: userId es null, usando customerId: $userId');
    }

    // ✅ PRIORIDAD 3: Buscar 'user.id' (si viene un objeto anidado)
    if (userId == null || userId.isEmpty) {
      final userObj = json['user'];
      if (userObj is Map<String, dynamic>) {
        userId = userObj['id'] as String?;
        debugPrint('⚠️ SESSION.fromJson: userId es null, usando user.id: $userId');
      }
    }

    // ✅ Si todavía es null, lanzar error descriptivo
    if (userId == null || userId.isEmpty) {
      throw Exception(
        'No se pudo extraer userId de la respuesta de login. '
        'JSON recibido: $json'
      );
    }

    debugPrint('✅ SESSION.fromJson: UserId final: $userId');

    return Session(
      token: json['token'] as String? ?? '',
      user: User.fromUserId(userId),
      expiration: json.containsKey('expiration') && json['expiration'] != null 
          ? DateTime.parse(json['expiration'] as String) 
          : null,
    );
  }
}

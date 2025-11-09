import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

class Session {
  final String token;
  final DateTime? expiration;
  final User user; // 🛑 Referencia al objeto User (con el customerId)

  Session({required this.token, required this.user, this.expiration});
  
  factory Session.fromJson(Map<String, dynamic> json) {
    // Obtenemos el ID directamente del JSON
    final String customerId = json['customerId']; 

    return Session(
      token: json['token'],
      // Creamos el objeto User usando el ID obtenido
      user: User.fromCustomerId(customerId), 
      expiration: json.containsKey('expiration') && json['expiration'] != null 
                  ? DateTime.parse(json['expiration']) 
                  : null, 
    );
  }
}
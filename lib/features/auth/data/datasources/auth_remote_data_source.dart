import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Session> login(String email, String password) async {
    final body = {'email': email, 'password': password};
    
    // El método POST a /login NUNCA debe requerir autenticación.
    // Asumimos que apiClient.post ya maneja que si no hay token guardado, no se adjunta header.
    // Si tu apiClient siempre adjunta el token guardado, debes añadir: requiresAuth: false
    final response = await apiClient.post(
      '/customer/login', 
      body: body,
    );

    final String token = response['token'];
    final String customerId = response['customerId'];
    
    // Creamos el objeto User y luego la Session
    final user = User(id: customerId); 

    return Session(token: token, user: user);
  }


  Future<User> register({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String celular,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
    };

    // El registro tampoco requiere autenticación previa.
    final response = await apiClient.post('/customer/register', body: body);

    // 🛑 ASUMO que el backend devuelve un objeto con la llave 'userId' 🛑
    return User(id: response['userId']);
  }
}
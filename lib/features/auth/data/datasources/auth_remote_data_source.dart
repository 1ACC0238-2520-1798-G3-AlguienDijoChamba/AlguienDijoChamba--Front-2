import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Session> login(String email, String password) async {
    final body = {'email': email, 'password': password};
    final response = await apiClient.post('/customer/login', body: body);

    return Session(token: response['token']);
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

    final response = await apiClient.post('/customer/register', body: body);

    
    return User(id: response['userId']);
  }



}
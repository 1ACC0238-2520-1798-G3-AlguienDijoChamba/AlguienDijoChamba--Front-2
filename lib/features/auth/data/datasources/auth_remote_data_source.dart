import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Session> login(String email, String password) async {
    final body = {'email': email, 'password': password};
    final response = await apiClient.post('/iam/login', body: body);

    return Session(token: response['token']);
  }


  Future<User> register({
    required String email,
    required String password,
    required String dni,
    required String nombres,
    required String apellidos,
    required String celular,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'dni': dni,
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
    };

    final response = await apiClient.post('/iam/register', body: body);


    return User(
      id: response['id'],
      email: response['email'],
      nombres: response['nombres'],
      apellidos: response['apellidos'],
      dni: response['dni'],
      celular: response['celular'],
    );
  }



}
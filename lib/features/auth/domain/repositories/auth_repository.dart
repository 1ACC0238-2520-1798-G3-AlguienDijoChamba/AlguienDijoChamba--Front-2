import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Session> login(String email, String password);
  Future<User> register({
    required String email,
    required String password,
    required String dni,
    required String nombres,
    required String apellidos,
    required String celular,
  });
}
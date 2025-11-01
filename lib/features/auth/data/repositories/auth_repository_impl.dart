import 'package:alguiendijochamba_app_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Session> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String dni,
    required String nombres,
    required String apellidos,
    required String celular,
  }) async {
    return await remoteDataSource.register(
      email: email,
      password: password,
      dni: dni,
      nombres: nombres,
      apellidos: apellidos,
      celular: celular,
    );
  }

}
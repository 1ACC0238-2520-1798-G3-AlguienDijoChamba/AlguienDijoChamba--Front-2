import 'package:alguiendijochamba_app_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart'; // Importar la dependencia de Storage

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage; // 1. Declarar la dependencia de Storage

  // 2. Modificar el constructor para requerir ambas dependencias
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage, 
  });

  @override
  Future<Session> login(String email, String password) async {
    // Llama a la API para obtener el token
    final session = await remoteDataSource.login(email, password);
    
    // 3. LÓGICA CRÍTICA: Guardar el token de forma asíncrona.
    // Esto resuelve el error de asincronía ('Token MISSING').
    await tokenStorage.saveToken(session.token); 

    return session;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String celular,
  }) async {
    return await remoteDataSource.register(
      email: email,
      password: password,
      nombres: nombres,
      apellidos: apellidos,
      celular: celular,
    );
  }
}
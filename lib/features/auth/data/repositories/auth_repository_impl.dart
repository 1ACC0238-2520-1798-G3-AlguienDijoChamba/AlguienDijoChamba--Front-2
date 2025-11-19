import 'dart:io';

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
  @override
  Future<void> saveCurrentUserId(String id) async {
    // Delega la lógica de guardado al TokenStorage (que ahora maneja IDs)
    await tokenStorage.saveUserId(id);
  }

  @override
  Future<String?> getCurrentUserId() async {
    // Delega la lógica de obtención al TokenStorage
    return tokenStorage.getUserId();
  }

  @override
  Future<void> completeProfile({
    required String customerId,
    required int preferredPaymentMethod,
    required bool acceptsBookingUpdates,
    required bool acceptsPromotionsAndOffers,
    required bool acceptsNewsletter,
  }) async {
    //  delegamos la llamada al Remote Data Source
    await remoteDataSource.completeProfile(
      customerId: customerId,
      preferredPaymentMethod: preferredPaymentMethod,
      acceptsBookingUpdates: acceptsBookingUpdates,
      acceptsPromotionsAndOffers: acceptsPromotionsAndOffers,
      acceptsNewsletter: acceptsNewsletter,
    );
  }
  @override
  Future<String> uploadProfilePhoto({
    required String customerId,
    required File photoFile,
  }) async {
    // Delega la llamada al Remote Data Source
    return await remoteDataSource.uploadProfilePhoto(
      customerId: customerId,
      photoFile: photoFile,
    );
  }
}
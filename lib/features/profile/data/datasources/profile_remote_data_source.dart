import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:flutter/material.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource({required this.apiClient});

  /// Obtiene el perfil del cliente (GET)
  Future<Map<String, dynamic>> getCustomerProfile(String userId) async {
    try {
      debugPrint(
        '📋 PROFILE REMOTE DS: Obteniendo perfil para userId: $userId',
      );

      // ✅ CORRECCIÓN: NO agregar /api/v1 porque ApiClient ya lo maneja
      final response = await apiClient.get(
        '/Customer/$userId/profile', // ← Sin /api/v1 al inicio
        requiresAuth: true,
      );

      debugPrint('✅ PROFILE REMOTE DS: Perfil obtenido exitosamente');
      return response;
    } catch (e) {
      debugPrint('❌ PROFILE REMOTE DS ERROR: $e');
      rethrow;
    }
  }

  /// Actualiza el perfil del cliente (PUT)
  Future<Map<String, dynamic>> updateCustomerProfile(
    String customerId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      debugPrint(
        '📋 PROFILE REMOTE DS: Actualizando perfil para customerId: $customerId',
      );

      final response = await apiClient.put(
        '/Customer/$customerId/profile',
        body: profileData,
        requiresAuth: true,
      );

      debugPrint('✅ PROFILE REMOTE DS: Perfil actualizado exitosamente');
      return response; // ✅ Devuelve el Map
    } catch (e) {
      debugPrint('❌ PROFILE REMOTE DS ERROR: $e');
      rethrow;
    }
  }

  /// Sube la foto de perfil (POST multipart)
  Future<String> uploadProfilePhoto(String userId, String photoPath) async {
    try {
      debugPrint('📸 PROFILE REMOTE DS: Subiendo foto para userId: $userId');

      final response = await apiClient.post(
        '/Customer/$userId/profile/photo', // ← Sin /api/v1 al inicio
        headers: {'Content-Type': 'multipart/form-data'},
        requiresAuth: true,
      );

      debugPrint('✅ PROFILE REMOTE DS: Foto subida exitosamente');
      return response['photoUrl'] ?? response['url'];
    } catch (e) {
      debugPrint('❌ PROFILE REMOTE DS ERROR: $e');
      rethrow;
    }
  }
}

// lib/features/notifications/data/datasources/notification_remote_data_source.dart

import 'package:alguiendijochamba_app_flutter/features/notifications/data/models/notification_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/errors/exceptions.dart'; // Asumiendo tu ruta de excepciones

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> dismissNotification(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    // rolePath será 'customers' o 'professionals'
    final response = await apiClient.get('/notifications/customers/$userId');
    
    if (response is List) {
      return response
          .map((jsonItem) => NotificationModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(message: 'Formato de respuesta de notificaciones inválido.');
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // PATCH /api/v1/notifications/{id}/mark-as-read
    await apiClient.patch(
      '/notifications/$notificationId/mark-as-read',
      body: null, // PATCH sin cuerpo
    );
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    // DELETE /api/v1/notifications/{id}
    await apiClient.delete(
      '/notifications/$notificationId',
    );
  }
}
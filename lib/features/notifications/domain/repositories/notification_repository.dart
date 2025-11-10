import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  // GET: Obtener notificaciones por ID de Cliente
  Future<List<NotificationEntity>> getCustomerNotifications(String customerId);

  // PATCH: Marcar como leída
  Future<void> markAsRead(String notificationId);

  // DELETE: Descartar (Soft Delete)
  Future<void> dismissNotification(String notificationId);
}
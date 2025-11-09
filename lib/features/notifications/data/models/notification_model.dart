import 'package:alguiendijochamba_app_flutter/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    super.status,
    required super.isRead,
    required super.createdAt,
    required super.profesionalId,
    required super.senderName,  
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      status: json['status'] as String?, // Nullable
      isRead: json['isRead'] as bool,
      // Asumiendo que el backend devuelve un string ISO 8601
      createdAt: DateTime.parse(json['createdAt'] as String), 
      profesionalId: json['profesionalId'] as String?,
      senderName: json['senderName'] as String?,
    );
  }
  
  // No se necesita toJson si el frontend no crea notificaciones
}
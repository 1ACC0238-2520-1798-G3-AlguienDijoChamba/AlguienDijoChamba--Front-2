import 'package:equatable/equatable.dart';

// --- Helper Functions ---
const Map<int, String> statusMap = {
  0: 'pending',
  1: 'inprogress',
  2: 'accepted',
  3: 'rejected',
  4: 'completed',
  5: 'discarded',
};
const Map<int, String> typeMap = {
  0: 'proffesionalmessage',
  1: 'adminmessage',
  2: 'subscriptionwarning',
};

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final String type; // Mapea al NotificationType
  final String? status; // Mapea al NotificationStatus (Opcional)
  final bool isRead;
  final DateTime createdAt;
  final String? profesionalId; // ¡Ya viene!
  final String? senderName;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.status,
    required this.isRead,
    required this.createdAt,
    required this.profesionalId,
    required this.senderName,
  });

  @override
  List<Object?> get props => [id, title, message, type, status, isRead, createdAt];

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    // Maneja el type que es obligatorio y usa default seguro
    final int typeInt = json['type'] as int;
    
    // 🛑 MEJORA: Manejar status como opcional o nulo 🛑
    final int? statusInt = json['status'] as int?; 
    
    // Obtiene la cadena de texto mapeada
    final String mappedType = typeMap[typeInt] ?? 'adminmessage'; 
    final String? mappedStatus = statusInt != null 
        ? statusMap[statusInt] 
        : null;

    return NotificationEntity(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      
      type: mappedType,
      status: mappedStatus, // Puede ser null
      
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      profesionalId: json['profesionalId'] as String?, // Capturar el ID
      senderName: json['senderName'] as String?,
    );
  }
}
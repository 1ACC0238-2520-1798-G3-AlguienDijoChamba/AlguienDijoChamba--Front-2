import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Asegúrate de que estas rutas sean correctas
import '../../domain/entities/notification_entity.dart'; 
import '../blocs/notification_cubit.dart'; 


// =======================================================
// === 1. HELPER FUNCTIONS (Lógica de Mapeo y Estilos) ===
// =======================================================

// Colores de Fondo para el Status Tag
Color _getStatusBgColor(String? status) {
  if (status == null) return const Color(0xFFDBDBDB);
  switch (status.toLowerCase()) {
    case 'accepted': return Colors.green.shade100;
    case 'rejected': return Colors.red.shade100;
    case 'completed': return Colors.blueGrey.shade100;
    case 'inprogress': return const Color(0xFFFEDEC2);
    case 'pending':
    default: return const Color(0xFFDBDBDB);
  }
}

// Colores de Texto para el Status Tag
Color _getStatusTextColor(String? status) {
  if (status == null) return const Color(0xFF7E7B78);
  switch (status.toLowerCase()) {
    case 'accepted': return Colors.green.shade700;
    case 'rejected': return Colors.red.shade700;
    case 'completed': return Colors.blueGrey.shade700;
    case 'inprogress': return const Color(0xFFB25A02);
    case 'pending':
    default: return const Color(0xFF7E7B78);
  }
}

// Icono de estatus para Professional/Service
IconData? _getStatusIcon(String? status) {
  if (status == null) return null;
  switch (status.toLowerCase()) {
    case 'accepted': return Icons.check_circle_outline;
    case 'rejected': return Icons.cancel_outlined;
    case 'completed': return Icons.verified;
    case 'inprogress': return Icons.access_time;
    case 'pending': return Icons.pending_actions;
    default: return null;
  }
}

// Builder para el Avatar/Logo basado en NotificationType
Widget _buildAvatar(String type, String? profesionalId) {
    final bool isServiceRelated = type.toLowerCase() == 'proffesionalmessage';
    
    // Si es mensaje de profesional, usa foto (NetworkImage si tuvieras la URL)
    if (isServiceRelated) {
      // Nota: Si tuvieras la URL de la foto (fotoPerfilUrl), la usarías aquí.
      // Actualmente, usa un placeholder para el profesional.
      return Container(
        width: 64,
        height: 64,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          image: const DecorationImage(
            image: NetworkImage("https://placehold.co/64x64/2563eb/ffffff?text=P"), 
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45372000),
          ),
        ),
      );
    }
    
    // Si es Admin o Suscripción: Usa el logo de la App
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB), 
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(
        Icons.message, 
        color: Colors.white,
        size: 32,
      ),
    );
}

// Builder para el nombre/título basado en NotificationType
String _buildTitle(String type, String? senderName) {
    final typeLower = type.toLowerCase();
    
    // Si es mensaje de profesional, usamos el nombre del emisor
    if (typeLower == 'proffesionalmessage' && senderName != null) {
        return senderName; 
    } 
    // Títulos fijos para Admin/Subscription
    else if (typeLower == 'adminmessage') {
      return 'Mensaje del Administrador';
    } else if (typeLower == 'subscriptionwarning') {
      return 'Advertencia de Suscripción';
    } 
    // Fallback, aunque el 'title' del JSON siempre debería usarse si el nombre falla.
    else {
      return senderName ?? 'Notificación';
    }
}


// =======================================================
// === 2. WIDGET PRINCIPAL ===
// =======================================================

class NotificationCardWidget extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCardWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();
    final bool isUnread = !notification.isRead;
    final Color backgroundColor = isUnread ? Colors.blue.shade50 : Colors.white;
    final String statusLower = notification.status?.toLowerCase() ?? 'pending';
    
    final bool showStatusTag = statusLower != 'discarded' && notification.status != null;
    
    // Usamos el senderName que viene del backend
    final String displayTitle = _buildTitle(notification.type, notification.senderName);

    const double contentLeftPosition = 79.99; 

    return GestureDetector(
      onTap: () {
        if (isUnread) {
          cubit.onMarkAsRead(notification.id);
        }
      },
      child: Container(
        width: 337.16,
        // CORRECCIÓN VERTICAL: Altura aumentada para evitar Bottom Overflow
        height: 180.0, 
        padding: const EdgeInsets.only(
          top: 17.35,
          left: 17.35,
          right: 17.35,
          bottom: 1.35,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.35,
              color: isUnread ? Colors.blue.shade200 : const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
             if (isUnread)
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 145.0, // Altura corregida
              child: Stack(
                children: [
                  // --- Sección Derecha (Contenido de Título, Mensaje, Botones) ---
                  Positioned(
                    left: contentLeftPosition,
                    top: 0,
                    child: Container(
                      width: 330, // ANCHO TOTAL PARA EL CONTENIDO
                      height: 145.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Título y Status Tag (HEADER ROW)
                          SizedBox(
                            width: double.infinity,
                            height: 27.99,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // CORRECCIÓN HORIZONTAL: Título Flexible
                                Flexible( 
                                  flex: 4,
                                  child: Container(
                                    height: 28,
                                    child: Text(
                                      displayTitle, 
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 18,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w700,
                                        height: 1.56 / 1.0, 
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(), 
                                
                                // Status Tag
                                if (showStatusTag)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), 
                                    decoration: ShapeDecoration(
                                      color: _getStatusBgColor(notification.status),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.35,
                                          color: _getStatusTextColor(notification.status).withOpacity(0.5),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      notification.status!.toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusTextColor(notification.status),
                                        fontSize: 12,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 7.99), // Espacio
                          
                          // 2. Mensaje Principal
                          Container(
                            width: double.infinity,
                            height: 57,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icono de Status
                                if (showStatusTag)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                                    child: Icon(
                                      _getStatusIcon(notification.status),
                                      color: _getStatusTextColor(notification.status),
                                      size: 18,
                                    ),
                                  ),
                                
                                // CORRECCIÓN DE ANCHO: Text envuelto en Expanded
                                Expanded( 
                                  child: Text(
                                    notification.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 14,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 7.99), // Espacio

                          // 3. Botones de Acción y Fecha
                          Container(
                            width: double.infinity,
                            height: 43.99,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Botón Dismiss
                                GestureDetector(
                                  onTap: () => cubit.onDismiss(notification.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                    height: 35,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFF2563EB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      shadows: [
                                        const BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1), spreadRadius: -1),
                                        const BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 1), spreadRadius: 0)
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text('Dismiss', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Arimo', fontWeight: FontWeight.w400, height: 1.50 / 1.0)),
                                    ),
                                  ),
                                ),
                                
                                // Botón Marcar como leído (Si está sin leer)
                                if (isUnread) 
                                  GestureDetector(
                                    onTap: () => cubit.onMarkAsRead(notification.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(width: 1.35, color: Color(0xFF2563EB)),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Leído',
                                        style: TextStyle(
                                          color: Color(0xFF2563EB),
                                          fontSize: 14,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                
                                // Fecha de Creación
                                Text(
                                  'Hace ${notification.createdAt.difference(DateTime.now()).inHours.abs()}h',
                                  style: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 12,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // --- Sección Izquierda (Avatar y Dots) ---
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 64,
                      height: 64,
                      child: Stack(
                        children: [
                          _buildAvatar(notification.type, notification.profesionalId), 
                          
                          // NOTA: EL CÍRCULO AZUL DE NO LEÍDO HA SIDO ELIMINADO SEGÚN TU PETICIÓN.
                            
                          // Punto Verde (Online/Offline)
                          Positioned(
                            left: 48, top: 47.97,
                            child: Container(width: 15.99, height: 15.99, decoration: ShapeDecoration(color: const Color(0xFF00C950), shape: RoundedRectangleBorder(side: const BorderSide(width: 1.35, color: Colors.white), borderRadius: BorderRadius.circular(45372000),))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
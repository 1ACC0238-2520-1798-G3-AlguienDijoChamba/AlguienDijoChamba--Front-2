import 'package:alguiendijochamba_app_flutter/features/notifications/presentation/blocs/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/dismiss_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';


class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final MarkAsReadUseCase markAsRead;
  final DismissNotificationUseCase dismissNotification;
  
  // 🛑 currentUserId se mantiene (necesario).
  final String currentUserId;
  // 🛑 currentUserRole: ELIMINADO ya que el rol es fijo (Customer).
  // final UserRole currentUserRole; 

  NotificationCubit({
    required this.getNotifications,
    required this.markAsRead,
    required this.dismissNotification,
    required this.currentUserId,
    // 🛑 Eliminamos el argumento del constructor
    // required this.currentUserRole, 
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    // Si ya hay datos, emitimos Loading manteniendo los datos para evitar un flash blanco
    emit(NotificationLoading(notifications: state.notifications)); 

    // 🛑 CORRECCIÓN: Llamada simplificada al UseCase, solo pasando el userId
    final result = await getNotifications(
      userId: currentUserId,
      // 🛑 Eliminamos el argumento 'role'
    );

    result.fold(
      (failure) => emit(NotificationError(
        message: 'Error al cargar: ${failure.message}', 
        notifications: state.notifications,
      )),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> performAction(
    String notificationId, 
    Future<void> Function(String) action,
  ) async {
    // 1. Marcar el estado como loading (usando el estado actual)
    emit(NotificationLoading(notifications: state.notifications));
    
    try {
      // 2. Ejecutar la acción
      await action(notificationId);
      
      // 3. Si tiene éxito, refrescar la lista para reflejar el cambio
      await loadNotifications();
      
    } catch (e) {
      // Si la acción falla, regresamos al estado anterior con un mensaje de error.
      emit(NotificationError(
        message: 'Fallo al ejecutar la acción: ${e.toString()}', 
        notifications: state.notifications,
      ));
    }
  }

  void onMarkAsRead(String notificationId) {
    performAction(notificationId, markAsRead);
  }

  void onDismiss(String notificationId) {
    performAction(notificationId, dismissNotification);
  }
}
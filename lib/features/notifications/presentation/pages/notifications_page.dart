import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/presentation/blocs/notification_state.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/mark_as_read_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/dismiss_notification_usecase.dart';

import '../blocs/notification_cubit.dart';
import '../widgets/notification_card_widget.dart';


class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Inyectar el repositorio
    final authRepository = injector<AuthRepository>(); 

    // 2. Usar FutureBuilder para esperar el ID del cliente
    return FutureBuilder<String?>(
      future: authRepository.getCurrentUserId(), // 🛑 Llamada asíncrona para obtener el ID guardado
      builder: (context, snapshot) {
        
        // Manejar estado de carga o error
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un loader mientras se carga el ID
          return const Center(child: CircularProgressIndicator());
        }

        // Manejar errores o ID nulo
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          // Si falla o no hay ID, asume error (ej. usuario no logueado)
          return const Center(child: Text('Error: No se pudo obtener el ID de usuario.'));
        }

        // El ID de cliente real (2674a6ee...)
        final String currentUserId = snapshot.data!; 

        // 3. Inicializar el Cubit con el ID real
        return BlocProvider(
          create: (context) => NotificationCubit(
            getNotifications: injector<GetNotificationsUseCase>(),
            markAsRead: injector<MarkAsReadUseCase>(),
            dismissNotification: injector<DismissNotificationUseCase>(),
            currentUserId: currentUserId,
          )..loadNotifications(), 
          
          child: const NotificationsView(),
        );
      },
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco como solicitaste
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: TopBar(title: 'Mis Notificaciones'), // Usa tu TopBar global
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // 1. Mostrar estado de carga inicial
          if (state is NotificationInitial || (state is NotificationLoading && state.notifications.isEmpty)) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
          }

          // 2. Lista vacía (solo si no está cargando y no hay datos)
          if (state.notifications.isEmpty && state is! NotificationLoading) {
            return const Center(
              child: Text(
                'No tienes notificaciones.',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            );
          }
          
          // 3. Mostrar la lista con indicador de refresco (o el estado de error)
          return RefreshIndicator(
            onRefresh: context.read<NotificationCubit>().loadNotifications,
            color: const Color(0xFF2563EB),
            child: ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCardWidget(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}
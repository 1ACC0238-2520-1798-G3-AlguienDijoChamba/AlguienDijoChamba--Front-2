import 'package:alguiendijochamba_app_flutter/features/notifications/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';


abstract class NotificationState extends Equatable {
  final List<NotificationEntity> notifications;

  const NotificationState({this.notifications = const []});

  @override
  List<Object> get props => [notifications];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  // Cuando carga, mantenemos las notificaciones antiguas para una mejor UX
  const NotificationLoading({required super.notifications});
}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded({required super.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError({required this.message, required super.notifications});

  @override
  List<Object> get props => [message, notifications];
}
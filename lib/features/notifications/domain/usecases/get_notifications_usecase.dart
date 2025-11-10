// Archivo: GetNotificationsUseCase.dart

import 'package:alguiendijochamba_app_flutter/core/errors/failures.dart'; // Asumiendo tu ruta de fallos
import 'package:dartz/dartz.dart'; // Usando dartz para Either
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

// 🛑 ELIMINAMOS el enum UserRole ya que solo usaremos Customer.
// enum UserRole { customer, professional } 

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call({
    // 🛑 Corregido: Solo necesitamos el userId, el rol es implícito.
    required String userId, 
    // required UserRole role, // Eliminado
  }) async {
    try {
      List<NotificationEntity> notifications;
      
      // 🛑 Eliminamos el if/else y llamamos directamente al método de Customer.
      notifications = await repository.getCustomerNotifications(userId);
      
      return Right(notifications);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
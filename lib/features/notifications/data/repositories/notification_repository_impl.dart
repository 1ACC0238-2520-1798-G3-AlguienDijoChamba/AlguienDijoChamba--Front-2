import 'package:alguiendijochamba_app_flutter/core/errors/exceptions.dart';
import 'package:alguiendijochamba_app_flutter/core/errors/failures.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getCustomerNotifications(String customerId) async {
    try {
      final models = await remoteDataSource.getNotifications(customerId);
      return models; // Retorna la lista de modelos (que extiende la entidad)
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }


  
  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  @override
  Future<void> dismissNotification(String notificationId) async {
    try {
      await remoteDataSource.dismissNotification(notificationId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }
}
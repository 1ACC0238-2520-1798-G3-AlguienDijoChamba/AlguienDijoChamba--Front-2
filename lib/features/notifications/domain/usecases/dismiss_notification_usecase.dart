import 'package:alguiendijochamba_app_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/notification_repository.dart';

class DismissNotificationUseCase {
  final NotificationRepository repository;

  DismissNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String notificationId) async {
    try {
      await repository.dismissNotification(notificationId);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
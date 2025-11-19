import 'dart:io';
import '../repositories/auth_repository.dart';

class UploadProfilePhoto {
  final AuthRepository repository;

  UploadProfilePhoto(this.repository);

  Future<String> call({
    required String customerId,
    required File photoFile,
  }) {
    return repository.uploadProfilePhoto(
      customerId: customerId,
      photoFile: photoFile,
    );
  }
}
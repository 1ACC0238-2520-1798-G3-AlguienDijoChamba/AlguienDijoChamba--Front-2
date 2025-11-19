import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/upload_profile_photo.dart';

// --- Events ---
abstract class UploadPhotoEvent {}

/// Evento para iniciar la subida de la foto.
class SubmitUploadPhotoEvent extends UploadPhotoEvent {
  final String customerId;
  final File photoFile;

  SubmitUploadPhotoEvent({
    required this.customerId,
    required this.photoFile,
  });
}

// --- States ---
abstract class UploadPhotoState {}
class UploadPhotoInitial extends UploadPhotoState {}
class UploadPhotoLoading extends UploadPhotoState {}

/// Estado de éxito, contiene la URL devuelta por el servidor.
class UploadPhotoSuccess extends UploadPhotoState {
  final String photoUrl;
  UploadPhotoSuccess(this.photoUrl);
}
class UploadPhotoFailure extends UploadPhotoState {
  final String error;
  UploadPhotoFailure(this.error);
}

// --- BLoC ---
class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final UploadProfilePhoto uploadProfilePhoto;

  UploadPhotoBloc({required this.uploadProfilePhoto}) : super(UploadPhotoInitial()) {
    on<SubmitUploadPhotoEvent>((event, emit) async {
      emit(UploadPhotoLoading());
      try {
        // Llama al Use Case de subida de foto
        final photoUrl = await uploadProfilePhoto(
          customerId: event.customerId,
          photoFile: event.photoFile,
        );
        emit(UploadPhotoSuccess(photoUrl));
      } catch (e) {
        emit(UploadPhotoFailure(e.toString()));
      }
    });
  }
}
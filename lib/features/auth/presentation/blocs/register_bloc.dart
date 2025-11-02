import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class RegisterEvent {}
class SubmitRegisterEvent extends RegisterEvent {
  final String nombres;
  final String apellidos;
  final String email;
  final String password;
  final String celular;
  final String dni;

  SubmitRegisterEvent({
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.celular,
    required this.dni,
  });
}

abstract class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {
  final User user;
  RegisterSuccess(this.user);
}
class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUser registerUser;

  RegisterBloc({required this.registerUser}) : super(RegisterInitial()) {
    on<SubmitRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = await registerUser(
          nombres: event.nombres,
          apellidos: event.apellidos,
          email: event.email,
          password: event.password,
          celular: event.celular,
        );
        emit(RegisterSuccess(user));
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}

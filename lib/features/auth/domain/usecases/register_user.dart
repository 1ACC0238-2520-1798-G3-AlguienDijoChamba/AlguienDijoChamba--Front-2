import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String celular,
  }) {
    return repository.register(
      email: email,
      password: password,
      nombres: nombres,
      apellidos: apellidos,
      celular: celular,
    );
  }
}

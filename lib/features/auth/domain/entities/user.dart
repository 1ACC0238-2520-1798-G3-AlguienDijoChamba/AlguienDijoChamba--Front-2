/// Representa un usuario autenticado en sesión
class User {
  final String id;  // Este es el userId del JWT (de la tabla Users)

  User({required this.id});

  // Factory para crear desde customerId (retrocompatibilidad)
  factory User.fromCustomerId(String customerId) {
    return User(id: customerId);
  }

  // Factory para crear desde userId
  factory User.fromUserId(String userId) {
    return User(id: userId);
  }
}

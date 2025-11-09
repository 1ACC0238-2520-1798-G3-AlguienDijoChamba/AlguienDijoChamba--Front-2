class User {
  final String id; 

  User({required this.id});
  
  factory User.fromCustomerId(String customerId) {
    return User(id: customerId);
  }
}
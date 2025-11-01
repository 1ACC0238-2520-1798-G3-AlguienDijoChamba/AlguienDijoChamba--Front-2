import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';

class AppRouter {
  final RegisterUser registerUser;
  final LoginUser loginUser;

  AppRouter({required this.registerUser, required this.loginUser});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(registerUser: registerUser),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(loginUser: loginUser),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

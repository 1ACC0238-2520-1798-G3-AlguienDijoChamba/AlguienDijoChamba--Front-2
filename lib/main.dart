import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/core/navigation/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  final appRouter = AppRouter(registerUser: registerUserUseCase, loginUser: loginUserUseCase);
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: '/register',
    );
  }
}

import 'package:alguiendijochamba_app_flutter/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart'; 

// Importa tus Use Cases
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';


// 🛑 Define/Asigna las instancias necesarias para AppRouter
// Deberías obtener estas instancias de tu inyector (injector.dart)
final RegisterUser registerUserUseCase = injector<RegisterUser>();
final LoginUser loginUserUseCase = injector<LoginUser>();
final SearchProfessionalsUseCase searchProfessionalsUseCase = injector<SearchProfessionalsUseCase>();
final GetAllTagsUseCase getAllTagsUseCase = injector<GetAllTagsUseCase>();


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🛑 Inicializa AppRouter con TODAS las dependencias necesarias
  final appRouter = AppRouter(
    registerUser: registerUserUseCase,
    loginUser: loginUserUseCase,
    // ¡NUEVAS DEPENDENCIAS INCLUIDAS!
    searchProfessionalsUseCase: searchProfessionalsUseCase,
    getAllTagsUseCase: getAllTagsUseCase,
  );
  
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
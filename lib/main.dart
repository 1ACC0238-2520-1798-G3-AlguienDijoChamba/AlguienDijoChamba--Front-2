import 'package:alguiendijochamba_app_flutter/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';

// --- IMPORTACIONES DE USECASES ---
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';

// --- 🛑 IMPORTACIONES FALTANTES (AGREGA ESTAS DOS) ---
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart'; // Para TokenStorage
import 'package:alguiendijochamba_app_flutter/core/api/signalr_service.dart';   // Para SignalRService

// Define/Asigna las instancias necesarias para AppRouter
final RegisterUser registerUserUseCase = injector<RegisterUser>();
final LoginUser loginUserUseCase = injector<LoginUser>();
final SearchProfessionalsUseCase searchProfessionalsUseCase = injector<SearchProfessionalsUseCase>();
final GetAllTagsUseCase getAllTagsUseCase = injector<GetAllTagsUseCase>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa AppRouter y dependencias
  final appRouter = AppRouter(
    registerUser: registerUserUseCase,
    loginUser: loginUserUseCase,
    searchProfessionalsUseCase: searchProfessionalsUseCase,
    getAllTagsUseCase: getAllTagsUseCase,
  );

  // 🛑 NUEVO: Intentar reconectar SignalR si hay sesión activa
  // Ahora 'TokenStorage' será reconocido gracias al import
  final tokenStorage = injector<TokenStorage>(); 
  final token = await tokenStorage.getToken();

  if (token != null && token.isNotEmpty) {
    print("🔄 Main: Sesión detectada, conectando SignalR...");
    try {
      // Ahora 'SignalRService' será reconocido gracias al import
      injector<SignalRService>().connect(); 
    } catch (e) {
      print("Error conectando SignalR al inicio: $e");
    }
  }

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
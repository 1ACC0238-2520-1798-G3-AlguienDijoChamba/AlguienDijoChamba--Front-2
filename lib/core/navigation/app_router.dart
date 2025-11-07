// Archivo: AppRouter.dart (CORREGIDO)

import 'package:alguiendijochamba_app_flutter/features/shared/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
// Importaciones de Search
import '../../features/search/domain/usecases/search_professionals_usecase.dart';
import '../../features/search/domain/usecases/get_all_tags_usecase.dart';
import '../../features/search/presentation/pages/search_page.dart'; // Asegúrate de que la ruta de importación es correcta
// Importaciones de Plans and Benefits
import '../../features/plansbenefits/presentation/pages/plans_page.dart';
import '../../features/plansbenefits/presentation/pages/how_to_level_page.dart';



class AppRouter {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final SearchProfessionalsUseCase searchProfessionalsUseCase;
  final GetAllTagsUseCase getAllTagsUseCase;

  AppRouter({
    required this.registerUser, 
    required this.loginUser,
    required this.searchProfessionalsUseCase,
    required this.getAllTagsUseCase,
  });

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
      
      // 1. RUTA DE BÚSQUEDA (USADA POR PersistentBottomNavBar Y HomeHeader)

      case '/search_page': 
        return MaterialPageRoute(
          builder: (_) => SearchPage(
            searchUseCase: searchProfessionalsUseCase,
            getAllTagsUseCase: getAllTagsUseCase,
          ),
        );
        
      // 1. RUTA DE PLANES Y BENEFICIOS
      // 1. RUTA DE PLANES Y BENEFICIOS
      case '/plans_and_benefits':
        return MaterialPageRoute(
          builder: (_) => const PlansPage(), // ✅ ahora apunta a tu pantalla real
        );

      // 2. Ruta adicional: cómo subir de nivel
      case '/howToLevel':
        return MaterialPageRoute(
          builder: (_) => const HowToLevelPage(),
        );

            
      // 2. RUTA DE NOTIFICACIONES
      case '/notifications':
        return MaterialPageRoute(
          // 🛑 Usamos PlaceholderScreen
          builder: (_) => const PlaceholderScreen(title: 'Notificaciones'),
        );

      // 3. RUTA DE CHAT
      case '/chat':
        return MaterialPageRoute(
          // 🛑 Usamos PlaceholderScreen
          builder: (_) => const PlaceholderScreen(title: 'Chat'),
        );

      // 4. RUTA DE PERFIL (VERSIÓN FULLSCREEN)
      case '/profile_page_full':
        return MaterialPageRoute(
          // 🛑 Usamos PlaceholderScreen
          builder: (_) => const PlaceholderScreen(title: 'Mi Perfil'),
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
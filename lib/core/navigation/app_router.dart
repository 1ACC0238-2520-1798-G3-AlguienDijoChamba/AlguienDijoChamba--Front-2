// Archivo: AppRouter.dart (COMPLETO Y CORREGIDO)

import 'package:alguiendijochamba_app_flutter/features/shared/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';

// --- Importaciones de Páginas ---
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
// import '../../features/professionals/presentation/pages/professional_details_page.dart';

// --- Importaciones de UseCases ---
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/search/domain/usecases/search_professionals_usecase.dart';
import '../../features/search/domain/usecases/get_all_tags_usecase.dart';

// --- Importaciones para PROCESS FEATURE ---
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../core/di/injector.dart';
import '../../features/process/presentation/blocs/process_bloc.dart';
import '../../features/process/presentation/pages/professional_detail_page.dart';

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
      // ----------------------------------------------------
      // RUTAS DE AUTENTICACIÓN
      // ----------------------------------------------------
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(registerUser: registerUser),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(loginUser: loginUser),
        );
        
      // ----------------------------------------------------
      // RUTA DE BÚSQUEDA
      // ----------------------------------------------------
      case '/search_page': 
        return MaterialPageRoute(
          builder: (_) => SearchPage(
            searchUseCase: searchProfessionalsUseCase,
            getAllTagsUseCase: getAllTagsUseCase,
          ),
        );
        
      // ==========================================
      // ✨ PROCESS FEATURE - NUEVAS RUTAS
      // ✨ NOTA: MultiProvider proporciona ProcessBloc a TODAS las pantallas
      //          de esta rama, evitando ProviderNotFoundError
      // ==========================================
      case '/professional_details':
        // ✅ RECIBIR Y VALIDAR EL ID
        final professionalId = settings.arguments;
        
        if (professionalId == null || professionalId.toString().isEmpty) {
          print('❌ ERROR: professionalId es null o vacío');
          return MaterialPageRoute(
            builder: (_) => const PlaceholderScreen(
              title: 'Error: ID del profesional no proporcionado',
            ),
          );
        }

        print('✅ RUTA PROFESIONAL: Navegando a Professional Detail con ID: $professionalId');
        
        // ✅ NAVEGACIÓN CORRECTA CON MULTIPROVIDER
        // MultiProvider envuelve la página y proporciona ProcessBloc
        // a ella y a TODAS sus páginas secundarias
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              BlocProvider<ProcessBloc>.value(
                value: injector<ProcessBloc>(),
              ),
            ],
            child: ProfessionalDetailPage(
              professionalId: professionalId.toString(),
            ),
          ),
        );

        
      // ----------------------------------------------------
      // OTRAS RUTAS DE LA APP (Usan PlaceholderScreen temporalmente)
      // ----------------------------------------------------
      case '/plans_and_benefits':
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Planes y Beneficios'), 
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Notificaciones'),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Chat'),
        );
      case '/profile_page_full':
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Mi Perfil'),
        );
        
      // ----------------------------------------------------
      // RUTA POR DEFECTO / ERROR
      // ----------------------------------------------------
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

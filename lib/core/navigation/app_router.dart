// Archivo: AppRouter.dart (COMPLETO Y CORREGIDO)

import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/complete_profile.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/upload_profile_photo.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/blocs/complete_profile_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/blocs/upload_photo_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

// --- Placeholder temporal para la nueva ruta (CORREGIDO) ---
class ProfessionalDetailsPage extends StatelessWidget {
  // 💡 CORRECCIÓN: Ahora espera un String
  final String professionalId;
  const ProfessionalDetailsPage({super.key, required this.professionalId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Profesional')),
      body: Center(
        child: Text('Cargando datos para el Profesional ID: $professionalId', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
// ------------------------------------------------------------------


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
          builder: (_) => LoginPage(
            loginUser: loginUser,
            // 🛑 Añadir las nuevas dependencias requeridas por LoginPage 🛑
            apiClient: injector<ApiClient>(),
            authRepository: injector<AuthRepository>(),
          ),
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
        

      case '/complete_profile':
        final customerId = settings.arguments as String?; 
        
        if (customerId == null) {
            return MaterialPageRoute(
              builder: (_) => const PlaceholderScreen(title: 'Error de Navegación: Customer ID no proporcionado'),
            );
        }
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              // BLoC para la subida de foto (Multipart)
              BlocProvider(
                create: (_) => UploadPhotoBloc(
                  uploadProfilePhoto: injector<UploadProfilePhoto>(),
                ),
              ),
              // BLoC para la actualización final de preferencias (JSON)
              BlocProvider(
                create: (_) => CompleteProfileBloc(
                  completeProfile: injector<CompleteProfile>(),
                ),
              ),
            ],
            // Pasamos el customerId a la página
            child: CompleteProfilePage(customerId: customerId),
          ),
        );
        
      // ----------------------------------------------------
      // 🚀 RUTA DE DETALLES DEL PROFESIONAL (CORREGIDA)
      // ----------------------------------------------------
      case '/professional_details': 
        // 💡 CORRECCIÓN: Esperamos un String para el ID.
        final professionalId = settings.arguments as String?; 
        
        if (professionalId == null) {
            // Si el ID es nulo, mostramos una pantalla de error
            return MaterialPageRoute(
              builder: (_) => const PlaceholderScreen(title: 'Error de Navegación: ID no proporcionado'),
            );
        }

        // Navegamos a la pantalla de detalles, pasando el ID (como String)
        return MaterialPageRoute(
          builder: (_) => ProfessionalDetailsPage(professionalId: professionalId),
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
        builder: (_) => const NotificationsPage(),
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
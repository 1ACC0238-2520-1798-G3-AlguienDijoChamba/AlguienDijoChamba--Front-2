import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/core/widgets/main_navbar.dart';
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
import '../../features/home/presentation/pages/home_page.dart';

// --- Importaciones de UseCases ---
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/search/domain/usecases/search_professionals_usecase.dart';
import '../../features/search/domain/usecases/get_all_tags_usecase.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';

// --- Importaciones para PROCESS FEATURE ---
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../features/process/presentation/blocs/process_bloc.dart';
import '../../features/process/presentation/blocs/process_event.dart';
import '../../features/process/presentation/pages/professional_detail_page.dart';
import '../../features/process/domain/usecases/get_professional_detail.dart';
import '../../features/process/domain/usecases/create_job_request.dart';
import '../../features/process/domain/usecases/complete_job.dart';
import '../../features/process/domain/usecases/cancel_job.dart';
import '../../features/process/domain/repositories/process_repository.dart';

class AppRouter {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final SearchProfessionalsUseCase searchProfessionalsUseCase;
  final GetAllTagsUseCase getAllTagsUseCase;
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  AppRouter({
    required this.registerUser,
    required this.loginUser,
    required this.searchProfessionalsUseCase,
    required this.getAllTagsUseCase,
    required this.getProfile,
    required this.updateProfile,
  });

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ────────────────────────────────────────────────────────
      // RUTAS DE AUTENTICACIÓN
      // ────────────────────────────────────────────────────────
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(registerUser: registerUser),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            loginUser: loginUser,
            apiClient: injector<ApiClient>(),
            authRepository: injector<AuthRepository>(),
          ),
        );

      // ────────────────────────────────────────────────────────
      // RUTA PRINCIPAL (HOME CON BOTTOM NAV)
      // ────────────────────────────────────────────────────────
      case '/main':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProcessBloc>(
            create: (_) => ProcessBloc(
              getProfessionalDetail: injector<GetProfessionalDetail>(),
              createJobRequest: injector<CreateJobRequest>(),
              completeJob: injector<CompleteJob>(),
              cancelJob: injector<CancelJob>(),
              repository: injector<ProcessRepository>(),
            )..add(const LoadAvailableJobs()),
            child: const MainPage(),
          ),
        );

      // ────────────────────────────────────────────────────────
      // RUTA DE BÚSQUEDA
      // ────────────────────────────────────────────────────────
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

      // ────────────────────────────────────────────────────────
      // OTRAS RUTAS DE LA APP (Placeholder temporalmente)
      // ────────────────────────────────────────────────────────
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

      // ────────────────────────────────────────────────────────
      // RUTA POR DEFECTO / ERROR
      // ────────────────────────────────────────────────────────
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

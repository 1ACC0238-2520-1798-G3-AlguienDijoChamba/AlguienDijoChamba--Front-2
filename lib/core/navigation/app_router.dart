import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/core/widgets/main_navbar.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';

// --- Importaciones de Páginas ---
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
// import '../../features/professionals/presentation/pages/professional_details_page.dart';
import '../../features/reward/presentation/pages/reward_page.dart'; 


// --- Importaciones de UseCases ---
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/search/domain/usecases/search_professionals_usecase.dart';
import '../../features/search/domain/usecases/get_all_tags_usecase.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';

// --- Importaciones para PROCESS FEATURE ---
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/process/presentation/blocs/process_bloc.dart';
import '../../features/process/presentation/blocs/process_event.dart';
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
          builder: (_) => ChatListPage(),   // 👈 sin const
        );

      case '/chat_detail':
        return MaterialPageRoute(
          builder: (_) => ChatDetailPage(),
          settings: settings, // 👈 IMPORTANTE
        );

      case '/profile_page_full':
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Mi Perfil'),
        );
      case '/rewards':
        return MaterialPageRoute(
          builder: (_) => const RewardPage(),
        );
        
      
      // ----------------------------------------------------
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

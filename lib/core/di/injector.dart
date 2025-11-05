import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage_impl.dart';
import 'package:alguiendijochamba_app_flutter/core/constants.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/datasources/professional_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/repositories/professional_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/professional_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_my_profile_usercase.dart';

// 1. Almacenamiento de Tokens
final TokenStorage tokenStorage = TokenStorageImpl();

// 2. Cliente API (Ahora recibe el tokenStorage)
final ApiClient apiClient = ApiClient(
    baseUrl: BASE_URL,
    tokenStorage: tokenStorage, 
);

final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
// 🔑 CORRECCIÓN CLAVE: Pasarle tokenStorage al repositorio de Auth.
// Esto es necesario porque el repositorio ahora guarda el token en el login.
final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    tokenStorage: tokenStorage, // <<-- ¡Línea agregada!
);
final LoginUser loginUserUseCase = LoginUser(authRepository); 
final RegisterUser registerUserUseCase = RegisterUser(authRepository);

// 3. Data Source de Professional (Limpio, usa ApiClient)
final ProfessionalRemoteDataSource professionalRemoteDataSource =
    ProfessionalRemoteDataSourceImpl(apiClient);

// 4. Repository
final ProfessionalRepository professionalRepository =
    ProfessionalRepositoryImpl(professionalRemoteDataSource);

// 5. Use Case
final GetProfessionalsListUseCase getProfessionalsListUseCase =
    GetProfessionalsListUseCase(professionalRepository);
    
// Exporta la instancia para usarla en MainPage
final ProfessionalRepository professionalRepositoryInstance = professionalRepository;
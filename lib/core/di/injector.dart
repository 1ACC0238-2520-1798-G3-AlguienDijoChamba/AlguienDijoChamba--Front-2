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
import 'package:alguiendijochamba_app_flutter/features/search/data/datasources/tag_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/repositories/professional_repository_impl.dart' hide ProfessionalRemoteDataSourceImpl;
import 'package:alguiendijochamba_app_flutter/features/search/data/repositories/tag_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/professional_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/tag_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_my_profile_usercase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/process/data/datasources/process_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/process/data/repositories/process_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/repositories/process_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/get_professional_detail.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/create_job_request.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/complete_job.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/usecases/cancel_job.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';


// ✨ BASE URL - ASEGÚRATE DE QUE ESTÉ EN constants.dart
// const String BASE_URL = 'http://10.0.2.2:5000/api/v1';  // Android Emulator
// const String BASE_URL = 'http://localhost:5000/api/v1';  // iOS Simulator
// const String BASE_URL = 'http://192.168.x.x:5000/api/v1';  // Real device


// 1. Almacenamiento de Tokens
final TokenStorage tokenStorage = TokenStorageImpl();


// 2. Cliente API (Ahora recibe el tokenStorage)
final ApiClient apiClient = ApiClient(
  baseUrl: BASE_URL,  // ✨ ASEGÚRATE QUE BASE_URL ESTÉ CORRECTO
  tokenStorage: tokenStorage,
);


// AUTH
final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
final AuthRepository authRepository = AuthRepositoryImpl(
  remoteDataSource: authRemoteDataSource,
  tokenStorage: tokenStorage,
);
final LoginUser loginUserUseCase = LoginUser(authRepository);
final RegisterUser registerUserUseCase = RegisterUser(authRepository);


// SEARCH
final ProfessionalRemoteDataSource professionalRemoteDataSource =
    ProfessionalRemoteDataSourceImpl(apiClient);
final ProfessionalRepository professionalRepository =
    ProfessionalRepositoryImpl(professionalRemoteDataSource, tagRepository);


final TagRemoteDataSource tagRemoteDataSource = TagRemoteDataSourceImpl(apiClient);
final TagRepository tagRepository = TagRepositoryImpl(tagRemoteDataSource);


final GetProfessionalsListUseCase getProfessionalsListUseCase =
    GetProfessionalsListUseCase(professionalRepository);
final SearchProfessionalsUseCase searchProfessionalsUseCase =
    SearchProfessionalsUseCase(
  professionalRepository,
  tagRepository,
);
final GetAllTagsUseCase getAllTagsUseCase = GetAllTagsUseCase(tagRepository);


final SearchCubit searchCubit = SearchCubit(
  searchProfessionalsUseCase: searchProfessionalsUseCase,
);


final TagFilterCubit tagFilterCubit = TagFilterCubit(
  getAllTagsUseCase: getAllTagsUseCase,
);


// ==========================================
// PROCESS FEATURE - Data Sources
// ==========================================
final ProcessRemoteDataSource processRemoteDataSource =
    ProcessRemoteDataSource(apiClient: apiClient);


// ==========================================
// PROCESS FEATURE - Repositories
// ==========================================
final ProcessRepository processRepository = ProcessRepositoryImpl(
  remoteDataSource: processRemoteDataSource,
);


// ==========================================
// PROCESS FEATURE - Use Cases
// ==========================================
final GetProfessionalDetail getProfessionalDetailUseCase =
    GetProfessionalDetail(processRepository);
final CreateJobRequest createJobRequestUseCase =
    CreateJobRequest(processRepository);
final CompleteJob completeJobUseCase =
    CompleteJob(processRepository);
final CancelJob cancelJobUseCase =
    CancelJob(processRepository);


// ==========================================
// PROCESS FEATURE - Blocs
// ==========================================
final ProcessBloc processBloc = ProcessBloc(
  getProfessionalDetail: getProfessionalDetailUseCase,
  createJobRequest: createJobRequestUseCase,
  completeJob: completeJobUseCase,
  cancelJob: cancelJobUseCase,
);


// ==========================================
// SERVICE LOCATOR (Inyección de dependencias)
// ==========================================
T injector<T>() {
  // ========== AUTENTICACIÓN ==========
  if (T == LoginUser) return loginUserUseCase as T;
  if (T == RegisterUser) return registerUserUseCase as T;
  
  // ========== BÚSQUEDA ==========
  if (T == SearchCubit) return searchCubit as T;
  if (T == TagFilterCubit) return tagFilterCubit as T;
  if (T == SearchProfessionalsUseCase) return searchProfessionalsUseCase as T;
  if (T == GetAllTagsUseCase) return getAllTagsUseCase as T;
  if (T == ProfessionalRepository) return professionalRepository as T;
  if (T == TagRepository) return tagRepository as T;

  // ========== PROCESS (Solicitudes y Pagos) ==========
  if (T == ProcessBloc) return processBloc as T;
  if (T == ProcessRepository) return processRepository as T;
  if (T == GetProfessionalDetail) return getProfessionalDetailUseCase as T;
  if (T == CreateJobRequest) return createJobRequestUseCase as T;
  if (T == CompleteJob) return completeJobUseCase as T;
  if (T == CancelJob) return cancelJobUseCase as T;
  
  // ========== CORE ==========
  if (T == ApiClient) return apiClient as T;
  if (T == TokenStorage) return tokenStorage as T;

  throw Exception("Dependencia no registrada: ${T.toString()}");
}

import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage_impl.dart';
import 'package:alguiendijochamba_app_flutter/core/constants.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/complete_profile.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/upload_profile_photo.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/repositories/notification_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/dismiss_notification_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/notifications/domain/usecases/mark_as_read_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/datasources/professional_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/datasources/tag_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/repositories/professional_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/search/data/repositories/professional_repository_impl.dart';
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
// =====================
// PROFILE FEATURE
// =====================
import 'package:alguiendijochamba_app_flutter/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/usecases/get_profile.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/usecases/update_profile.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';
import 'package:alguiendijochamba_app_flutter/core/api/signalr_service.dart'; // <-- NUEVO



// ✨ BASE URL - ASEGÚRATE DE QUE ESTÉ EN constants.dart
// const String BASE_URL = 'http://10.0.2.2:5000/api/v1';  // Android Emulator
// const String BASE_URL = 'http://localhost:5000/api/v1';  // iOS Simulator
// const String BASE_URL = 'http://192.168.x.x:5000/api/v1';  // Real device


// 1. Almacenamiento de Tokens
final TokenStorage tokenStorage = TokenStorageImpl();

// 2. Cliente API
final ApiClient apiClient = ApiClient(
  baseUrl: BASE_URL,
  tokenStorage: tokenStorage,
);

// AUTH
final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(
  apiClient: apiClient,
);
final AuthRepository authRepository = AuthRepositoryImpl(
  remoteDataSource: authRemoteDataSource,
  tokenStorage: tokenStorage,
);
final LoginUser loginUserUseCase = LoginUser(authRepository);
final RegisterUser registerUserUseCase = RegisterUser(authRepository);
final CompleteProfile completeProfileUseCase = CompleteProfile(authRepository); // 💡 NUEVO
final UploadProfilePhoto uploadProfilePhotoUseCase = UploadProfilePhoto(authRepository); // 💡 NUEVO





// SEARCH
final TagRemoteDataSource tagRemoteDataSource = TagRemoteDataSourceImpl(
  apiClient,
);
final TagRepository tagRepository = TagRepositoryImpl(tagRemoteDataSource);

final ProfessionalRemoteDataSource professionalRemoteDataSource =
    ProfessionalRemoteDataSourceImpl(apiClient);
final ProfessionalRepository professionalRepository =
    ProfessionalRepositoryImpl(professionalRemoteDataSource, tagRepository);

final GetProfessionalsListUseCase getProfessionalsListUseCase =
    GetProfessionalsListUseCase(professionalRepository);
final SearchProfessionalsUseCase searchProfessionalsUseCase =
    SearchProfessionalsUseCase(professionalRepository, tagRepository);
final GetAllTagsUseCase getAllTagsUseCase = GetAllTagsUseCase(tagRepository);

final SearchCubit searchCubit = SearchCubit(
  searchProfessionalsUseCase: searchProfessionalsUseCase,
);

final TagFilterCubit tagFilterCubit = TagFilterCubit(
  getAllTagsUseCase: getAllTagsUseCase,
);


// NOTIFICATIONS
final NotificationRemoteDataSource notificationRemoteDataSource =
    NotificationRemoteDataSourceImpl(apiClient);

final NotificationRepository notificationRepository =
    NotificationRepositoryImpl(notificationRemoteDataSource);

final GetNotificationsUseCase getNotificationsUseCase = GetNotificationsUseCase(
  notificationRepository,
);

final MarkAsReadUseCase markAsReadUseCase = MarkAsReadUseCase(
  notificationRepository,
);

final DismissNotificationUseCase dismissNotificationUseCase =
    DismissNotificationUseCase(notificationRepository);

// =====================
// PROCESS FEATURE
// =====================

// DataSource
final ProcessRemoteDataSource processRemoteDataSource = ProcessRemoteDataSource(
  apiClient: apiClient,
);

// Repository
final ProcessRepository processRepository = ProcessRepositoryImpl(
  remoteDataSource: processRemoteDataSource,
);

// UseCases
final GetProfessionalDetail getProfessionalDetailUseCase =
    GetProfessionalDetail(processRepository);

final CreateJobRequest createJobRequestUseCase = CreateJobRequest(
  processRepository,
);

final CompleteJob completeJobUseCase = CompleteJob(processRepository);

final CancelJob cancelJobUseCase = CancelJob(processRepository);

// ⚠️ OJO: NO creamos aquí un ProcessBloc global.
// Cada pantalla debe crear su propio ProcessBloc con estos usecases y el repository.

// =====================
// PROFILE FEATURE
// =====================

// DataSource
final ProfileRemoteDataSource profileRemoteDataSource = ProfileRemoteDataSource(
  apiClient: apiClient,
);

// Repository
final ProfileRepository profileRepository = ProfileRepositoryImpl(
  remoteDataSource: profileRemoteDataSource,
);

// UseCases
final GetProfile getProfileUseCase = GetProfile(profileRepository);

final UpdateProfile updateProfileUseCase = UpdateProfile(profileRepository);

// ⚠️ OJO: NO creamos aquí un ProfileBloc global.
// Cada pantalla debe crear su propio ProfileBloc con estos usecases y el repository.

// PROCESS
final ProcessRemoteDataSource processRemoteDataSource = 
    ProcessRemoteDataSource(apiClient: apiClient);

final ProcessRepository processRepository = 
    ProcessRepositoryImpl(remoteDataSource: processRemoteDataSource);

final GetProfessionalDetail getProfessionalDetail = 
    GetProfessionalDetail(processRepository);

final CreateJobRequest createJobRequest = 
    CreateJobRequest(processRepository);

final CompleteJob completeJob = 
    CompleteJob(processRepository);

final CancelJob cancelJob = 
    CancelJob(processRepository);

final ProcessBloc processBloc = ProcessBloc(
  getProfessionalDetail: getProfessionalDetail,
  createJobRequest: createJobRequest,
  completeJob: completeJob,
  cancelJob: cancelJob,
);

final SignalRService signalRService = SignalRService(
  tokenStorage: tokenStorage,
  processBloc: processBloc // Pasa la instancia del BLoC
);

T injector<T>() {
  // Token Storage
  if (T == TokenStorage) return tokenStorage as T;
  // Autenticación
  if (T == ApiClient) return apiClient as T;
  if (T == AuthRepository) return authRepository as T;
  if (T == LoginUser) return loginUserUseCase as T;
  if (T == RegisterUser) return registerUserUseCase as T;

  // Search
  if (T == SearchCubit) return searchCubit as T;
  if (T == TagFilterCubit) return tagFilterCubit as T;
  if (T == SearchProfessionalsUseCase) return searchProfessionalsUseCase as T;
  if (T == GetAllTagsUseCase) return getAllTagsUseCase as T;
  if (T == ProfessionalRepository) return professionalRepository as T;
  if (T == TagRepository) return tagRepository as T;
    // Autenticación
    if (T == ApiClient) return apiClient as T; 
    if (T == AuthRepository) return authRepository as T; 
    if (T == CompleteProfile) return completeProfileUseCase as T; 
    if (T == UploadProfilePhoto) return uploadProfilePhotoUseCase as T; 
    if (T == LoginUser) return loginUserUseCase as T;
    if (T == RegisterUser) return registerUserUseCase as T;
    if (T == SearchCubit) return searchCubit as T;
    if (T == TagFilterCubit) return tagFilterCubit as T;
    
    // Búsqueda y Filtros
    if (T == SearchProfessionalsUseCase) return searchProfessionalsUseCase as T;
    if (T == GetAllTagsUseCase) return getAllTagsUseCase as T;
    if (T == ProfessionalRepository) return professionalRepository as T;
    if (T == TagRepository) return tagRepository as T;

  // Notificaciones
  if (T == GetNotificationsUseCase) return getNotificationsUseCase as T;
  if (T == MarkAsReadUseCase) return markAsReadUseCase as T;
  if (T == DismissNotificationUseCase) return dismissNotificationUseCase as T;

  // Process (solo usecases y repo, NO el bloc)
  if (T == ProcessRepository) return processRepository as T;
  if (T == GetProfessionalDetail) return getProfessionalDetailUseCase as T;
  if (T == CreateJobRequest) return createJobRequestUseCase as T;
  if (T == CompleteJob) return completeJobUseCase as T;
  if (T == CancelJob) return cancelJobUseCase as T;

  // Profile (solo usecases y repo, NO el bloc)
  if (T == ProfileRepository) return profileRepository as T;
  if (T == GetProfile) return getProfileUseCase as T;
  if (T == UpdateProfile) return updateProfileUseCase as T;

  // ⚠️ Importante: aquí NO se registran ProfileBloc ni ProcessBloc.
  // Las pantallas deben crear sus propios bloques con BlocProvider usando estos casos de uso.

  throw Exception("Dependencia no registrada: $T");
    // Notificaciones
    if (T == GetNotificationsUseCase) return getNotificationsUseCase as T;
    if (T == MarkAsReadUseCase) return markAsReadUseCase as T;
    if (T == DismissNotificationUseCase) return dismissNotificationUseCase as T;
    
    // Process
    if (T == ProcessBloc) return processBloc as T;
    if (T == GetProfessionalDetail) return getProfessionalDetail as T;
    if (T == CreateJobRequest) return createJobRequest as T;
    if (T == CompleteJob) return completeJob as T;
    if (T == CancelJob) return cancelJob as T;
    if (T == ProcessRepository) return processRepository as T;

     if (T == ProcessBloc) return processBloc as T;
    
    // --- AÑADE EL NUEVO SERVICIO ---
    if (T == SignalRService) return signalRService as T;

    throw Exception("Dependencia no registrada: $T");
    
}

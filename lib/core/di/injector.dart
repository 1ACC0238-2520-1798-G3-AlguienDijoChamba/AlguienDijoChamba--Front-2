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

// 1. Almacenamiento de Tokens
final TokenStorage tokenStorage = TokenStorageImpl();

// 2. Cliente API (Ahora recibe el tokenStorage)
final ApiClient apiClient = ApiClient(
    baseUrl: BASE_URL,
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
final GetAllTagsUseCase getAllTagsUseCase =
    GetAllTagsUseCase(tagRepository);

final SearchCubit searchCubit = SearchCubit(
    searchProfessionalsUseCase: searchProfessionalsUseCase,
);

final TagFilterCubit tagFilterCubit = TagFilterCubit(
    getAllTagsUseCase: getAllTagsUseCase,
);

T injector<T>() {
    // Autenticación
    if (T == LoginUser) return loginUserUseCase as T;
    if (T == RegisterUser) return registerUserUseCase as T;
    if (T == SearchCubit) return searchCubit as T;
    if (T == TagFilterCubit) return tagFilterCubit as T;
    
    // Búsqueda y Filtros
    if (T == SearchProfessionalsUseCase) return searchProfessionalsUseCase as T;
    if (T == GetAllTagsUseCase) return getAllTagsUseCase as T;
    if (T == ProfessionalRepository) return professionalRepository as T;
    if (T == TagRepository) return tagRepository as T;
    
    throw Exception("Dependencia no registrada: $T");
}
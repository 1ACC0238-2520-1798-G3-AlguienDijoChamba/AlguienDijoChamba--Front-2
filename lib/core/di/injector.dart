import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/core/constants.dart';

// ApiClient
final ApiClient apiClient = ApiClient(baseUrl: BASE_URL);

// DataSource
final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);

// Repository
final AuthRepositoryImpl authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

// Casos de uso
final LoginUser loginUserUseCase = LoginUser(authRepository);
final RegisterUser registerUserUseCase = RegisterUser(authRepository);

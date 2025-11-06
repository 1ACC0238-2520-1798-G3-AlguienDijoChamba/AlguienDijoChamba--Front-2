import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';
import '../../../../core/api/api_client.dart';

/// Define la interfaz del datasource
abstract class ProfessionalRemoteDataSource {
  /// Obtiene el listado de reputaciones (búsqueda general)
  Future<List<dynamic>> searchProfessionals(SearchProfessionalsQuery query);

  /// Obtiene la reputación individual por ID
  Future<Map<String, dynamic>> getReputationByProfessionalId(String professionalId);

  /// Obtiene el perfil del profesional por ID
  Future<Map<String, dynamic>> getProfessionalProfileJson(String professionalId);
}

/// Implementación concreta
class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final ApiClient apiClient;

  ProfessionalRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<dynamic>> searchProfessionals(SearchProfessionalsQuery query) async {
    final params = query.toQueryParams();
    final endpoint = '/reputation';
    final responseData = await apiClient.get(endpoint, queryParams: params);

    if (responseData is! List) {
      throw Exception("Se esperaba una lista de resúmenes de reputación.");
    }
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> getReputationByProfessionalId(String professionalId) async {
    final response = await apiClient.get(
      '/reputation',
      queryParams: {'professionalId': professionalId},
    );

    if (response is! Map<String, dynamic>) {
      throw Exception("Formato de respuesta de reputación incorrecto.");
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> getProfessionalProfileJson(String professionalId) async {
    final responseData = await apiClient.get('/professionals/$professionalId');

    if (responseData is! Map<String, dynamic>) {
      throw Exception("Formato de respuesta de perfil individual incorrecto.");
    }
    return responseData;
  }
}

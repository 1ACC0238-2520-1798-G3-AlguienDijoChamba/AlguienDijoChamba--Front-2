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
    
    // 💡 LÍNEA DE DEBUG CRÍTICA
    final queryString = Uri(queryParameters: params).query;
    print('DEBUG BUSQUEDA API: $endpoint?$queryString'); // Esto imprimirá la URL completa

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

  // El backend devuelve una LISTA ([{...}]), aunque solo haya un resultado.
  if (response is! List || response.isEmpty) {
    throw Exception("Reputación no encontrada para el ID $professionalId o formato de respuesta incorrecto.");
  }

  // Tomamos el primer y único elemento de la lista.
  final reputationJson = response.first; 

  if (reputationJson is! Map<String, dynamic>) {
    throw Exception("El elemento de reputación para el ID $professionalId no es un objeto válido.");
  }

  return reputationJson;
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

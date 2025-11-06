// Archivo: lib/features/search/data/datasources/tag_remote_data_source.dart

import '../../../../core/api/api_client.dart'; 
import '../models/tag_model.dart';

abstract class TagRemoteDataSource {
  // 1. Lectura: Obtener todo el catálogo
  Future<List<TagModel>> getAllTags();
  
  // 2. NUEVO: Buscar IDs de profesionales por un solo tag
  Future<List<String>> getProfessionalIdsByTag({required String tagId});
}

class TagRemoteDataSourceImpl implements TagRemoteDataSource {
  final ApiClient apiClient;
  
  TagRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TagModel>> getAllTags() async {
    // ... (Tu implementación existente para GET /reputation/tags) ...
    final responseData = await apiClient.get('/reputation/tags');
    
    if (responseData is! List) {
      throw Exception("Se esperaba una lista de tags, pero se recibió un tipo de dato diferente.");
    }

    // Mapeo a TagModel
    return (responseData as List)
        .map((jsonItem) => TagModel.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }
  
  @override
  Future<List<String>> getProfessionalIdsByTag({required String tagId}) async {
    // Implementación para GET /api/v1/reputation/tags/{tagId}/professionals
    final responseData = await apiClient.get('/reputation/tags/$tagId/professionals');

    if (responseData is! List) {
      throw Exception("Se esperaba una lista de IDs de profesionales (String).");
    }

    // El endpoint devuelve una lista de IDs (String), los mapeamos directamente
    return (responseData as List).map((e) => e.toString()).toList();
  }
}
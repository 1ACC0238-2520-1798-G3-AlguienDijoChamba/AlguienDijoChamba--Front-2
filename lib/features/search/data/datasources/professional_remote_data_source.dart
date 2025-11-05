// Archivo: lib/features/professional/data/datasources/professional_remote_data_source.dart

import '../../../../core/api/api_client.dart'; 
import '../models/professional_model.dart';

abstract class ProfessionalRemoteDataSource {
  // 🚨 CORRECCIÓN 1: Cambiamos el contrato para que devuelva una LISTA
  Future<List<ProfessionalModel>> getAllProfessionals(); 
}

class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final ApiClient apiClient;

  ProfessionalRemoteDataSourceImpl(this.apiClient);

  @override
  // 🚨 CORRECCIÓN 2: Implementación para obtener la LISTA COMPLETA
  Future<List<ProfessionalModel>> getAllProfessionals() async {
    // La llamada no necesita headers, el ApiClient los añade automáticamente
    final responseData = await apiClient.get('/reputation');
    
    // Verificación de tipo: si el backend devuelve un solo objeto o null
    if (responseData is! List) {
      throw Exception("Se esperaba una lista de profesionales de /reputation, pero se recibió un tipo de dato diferente.");
    }

    // 🚨 CORRECCIÓN 3: El Mapeo CLAVE: Transformamos List<dynamic> a List<ProfessionalModel>
    final List<ProfessionalModel> professionalList = (responseData as List)
        // Usamos el constructor alternativo que hicimos para manejar el JSON de Reputación
        .map((jsonItem) => ProfessionalModel.fromReputationJson(jsonItem as Map<String, dynamic>))
        .toList();

    return professionalList;
  }
}
// Archivo: lib/features/professional/domain/usecases/get_my_profile_usecase.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';

import '../repositories/professional_repository.dart';

// Renombra esta clase a GetProfessionalsListUseCase para mayor claridad
class GetProfessionalsListUseCase { 
  final ProfessionalRepository repository;

  GetProfessionalsListUseCase(this.repository);

  // 🚨 Devuelve una LISTA
Future<List<SearchedProfessionalEntity>> call(SearchProfessionalsQuery query) async {
    // Llama al método unificado del repositorio
    return await repository.searchProfessionals(query);
  }
}
import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';

import '../repositories/professional_repository.dart';

class SearchProfessionalsUseCase {
  final ProfessionalRepository repository;

  SearchProfessionalsUseCase(this.repository);

  // Recibe la Query con todos los parámetros de búsqueda y filtro
  Future<List<SearchedProfessionalEntity>> call(SearchProfessionalsQuery query) async {
      // El repositorio ya devuelve el tipo correcto
      return await repository.searchProfessionals(query);
  }
}
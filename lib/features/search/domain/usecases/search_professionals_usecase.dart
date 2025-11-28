import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/professional_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/tag_repository.dart';

class SearchProfessionalsUseCase { 
  final ProfessionalRepository professionalRepository;
  final TagRepository tagRepository; // 💡 Inyectamos el TagRepository

  SearchProfessionalsUseCase(this.professionalRepository, this.tagRepository);

  Future<List<SearchedProfessionalEntity>> call(SearchProfessionalsQuery query) async {
    
    // 1. Manejo de Filtros por Tags: Pre-filtrado de IDs
    List<String> professionalIdsToFilter = [];
    
    if (query.tagIds.isNotEmpty) {
      // Si hay tags, obtenemos la lista de IDs que cumplen con la intersección de tags
      professionalIdsToFilter = await tagRepository.getProfessionalIdsByTags(
        tagIds: query.tagIds,
      );

      // Si se filtró por tags y el resultado es una lista vacía, no hay nada que buscar.
      if (professionalIdsToFilter.isEmpty) {
          return [];
      }
    }

    // 2. Construir la Query Final
    // Inyectamos los IDs de profesionales obtenidos (si hay tags), manteniendo
    // el resto de los parámetros (searchTerm, page, limit).
    query.copyWith(
      professionalIds: professionalIdsToFilter,
      // Nota: Eliminamos el 'tagIds' de la query final si ya usamos 'professionalIds',
      // ya que la API de /reputation espera solo uno o el otro. 
      // Sin embargo, si tu backend /reputation soporta ambos, puedes dejar tagIds.
      // Asumimos que la lógica de backend del /reputation ahora se basa en professionalIds si está presente.
    );

    // 3. Ejecutar la búsqueda en el Repositorio de Profesionales
    return await professionalRepository.searchProfessionals(query);  
  }
}
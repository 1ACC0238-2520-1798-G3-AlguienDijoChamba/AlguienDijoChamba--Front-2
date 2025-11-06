// Archivo: lib/features/search/data/repositories/tag_repository_impl.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';

import '../../domain/repositories/tag_repository.dart';
import '../datasources/tag_remote_data_source.dart';

class TagRepositoryImpl implements TagRepository {
  // Dependencia del DataSource para las llamadas HTTP
  final TagRemoteDataSource remoteDataSource;

  TagRepositoryImpl(this.remoteDataSource);

  // 1. LECTURA: Implementación de getAllTags (Catálogo)
  @override
  Future<List<TagEntity>> getAllTags() async {
    return await remoteDataSource.getAllTags();
  }
  
  // 2. NUEVO: Implementación de la búsqueda con lógica AND (intersección)
  @override
  Future<List<String>> getProfessionalIdsByTags({required List<String> tagIds}) async {
    if (tagIds.isEmpty) {
      // Si no hay tags seleccionados, devolvemos una lista vacía.
      return []; 
    }

    // A. Realizar todas las llamadas a la API de forma concurrente
    final futures = tagIds.map((tagId) {
      return remoteDataSource.getProfessionalIdsByTag(tagId: tagId);
    }).toList();
    
    // Esperamos a que todas las peticiones terminen
    final List<List<String>> resultsByTag = await Future.wait(futures);

    // B. Realizar la Intersección (AND lógico)
    // Inicializamos con el primer resultado (o un Set vacío si resultsByTag está vacío, aunque la validación superior lo evita)
    Set<String> commonProfessionals = resultsByTag.first.toSet(); 
    
    // Iteramos sobre el resto de las listas para encontrar IDs comunes
    for (int i = 1; i < resultsByTag.length; i++) {
      // RetainWhere mantiene solo los elementos que están también en la lista actual
      commonProfessionals.retainWhere((id) => resultsByTag[i].contains(id));
    }
    
    // Devolvemos la lista final de profesionales que tienen TODOS los tags
    return commonProfessionals.toList();
  }
}
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
      return [];
    }

    // Si solo hay un tag, lo buscamos directamente
    if (tagIds.length == 1) {
      return await remoteDataSource.getProfessionalIdsByTag(tagId: tagIds.first);
    }

    // 🌟 Lógica de Intersección para MÚLTIPLES Tags 🌟
    List<List<String>> listOfIdLists = [];

    // 1. Obtener la lista de IDs para CADA tag
    for (String tagId in tagIds) {
      final ids = await remoteDataSource.getProfessionalIdsByTag(tagId: tagId);
      listOfIdLists.add(ids);
    }
    
    // 2. Encontrar la INTERSECCIÓN (IDs presentes en TODAS las listas)
    // Usamos el primer conjunto como base y hacemos intersección con el resto.
    if (listOfIdLists.isEmpty) return [];

    Set<String> intersectionSet = listOfIdLists.first.toSet();

    for (int i = 1; i < listOfIdLists.length; i++) {
        intersectionSet = intersectionSet.intersection(listOfIdLists[i].toSet());
    }

    return intersectionSet.toList();
  }

}
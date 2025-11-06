// Archivo: lib/features/search/domain/repositories/tag_repository.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';

abstract class TagRepository {
  // LECTURA: Para obtener la lista de tags (catálogo)
  Future<List<TagEntity>> getAllTags(); 
  
  // NUEVO: Para obtener IDs de profesionales por uno o más tags
  Future<List<String>> getProfessionalIdsByTags({required List<String> tagIds});
}
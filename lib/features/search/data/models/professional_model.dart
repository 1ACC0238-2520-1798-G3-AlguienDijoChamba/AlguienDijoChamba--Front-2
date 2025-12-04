// Archivo: lib/features/search/data/models/professional_model.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/professional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import 'tag_model.dart'; // Importar el modelo de Tag

class ProfessionalModel extends ProfessionalEntity {
  // Constructor del Modelo
  const ProfessionalModel({
    required super.id, 
    required super.nombres,
    required super.apellidos,
    required super.professionalLevel,
    required super.starRating,
    required super.availableBalance, // Esto representa el hourlyRate en tu UI
    required super.fotoPerfilUrl,
    required super.tags, 
  });
  
  // Función auxiliar para mapear la lista de JSON a List<TagEntity>
  static List<TagEntity> _mapTags(List<dynamic>? tagsJson) {
    if (tagsJson == null) return const [];
    // Mapeamos de JSON a TagModel y lo devolvemos como TagEntity
    return tagsJson.map((tagJson) => TagModel.fromJson(tagJson as Map<String, dynamic>)).toList();
  }

  // Función auxiliar para limpiar el nivel profesional (ej: "Bronze Professional" -> "Bronze")
  static String _extractBadgeLevel(String? level) {
    if (level == null || level.isEmpty) return 'Bronze'; // Valor por defecto seguro
    
    if (level.contains('Gold')) return 'Gold';
    if (level.contains('Silver')) return 'Silver';
    if (level.contains('Platinum')) return 'Platinum';
    
    // Si contiene "Bronze" o cualquier otro caso por defecto
    return 'Bronze';
  }

  // 🚀 CONSTRUCTOR DE FÁBRICA OFICIAL (El que usa tu Data Source)
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      // ⚠️ Prioridad de IDs: Intenta 'professionalId', luego 'id', y finalmente un fallback '0'
      id: json['professionalId'] as String? ?? (json['id'] as String? ?? '0'), 
      
      // Mapeo seguro de nombres
      nombres: json['nombres'] as String? ?? 'Nombre Desconocido',
      apellidos: json['apellidos'] as String? ?? '',
      
      // 🚀 CORRECCIÓN: Limpieza del Nivel Profesional
      professionalLevel: _extractBadgeLevel(json['level'] as String? ?? json['professionalLevel'] as String?),
      
      // Conversión segura de números (int a double si es necesario)
      starRating: (json['rating'] ?? json['starRating'] ?? 0).toDouble(),
      
      // Mapeo de tarifa (hourlyRate viene como availableBalance o hourlyRate del backend)
      availableBalance: (json['hourlyRate'] ?? json['availableBalance'] ?? 0.0).toDouble(),
      
      // URL de foto segura
      fotoPerfilUrl: json['fotoPerfilUrl'] as String? ?? '', 
      
      // Mapeo de tags
      tags: _mapTags(json['tags'] as List<dynamic>?), 
    );
  }
}
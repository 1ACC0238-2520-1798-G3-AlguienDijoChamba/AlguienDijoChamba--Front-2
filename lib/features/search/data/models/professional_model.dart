import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/professional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import 'tag_model.dart'; // Importar el modelo de Tag (asumimos que existe)

class ProfessionalModel extends ProfessionalEntity {
  // Constructor del Modelo
  const ProfessionalModel({
    required super.id, 
    required super.nombres,
    required super.apellidos,
    required super.professionalLevel,
    required super.starRating,
    required super.availableBalance,
    required super.fotoPerfilUrl,
    required super.tags, 
  });
  
  // Mapeo del JSON de Tags (Función auxiliar)
  static List<TagEntity> _mapTags(List<dynamic>? tagsJson) {
    if (tagsJson == null) return const [];
    // Mapeamos de JSON a TagModel y lo devolvemos como TagEntity
    return tagsJson.map((tagJson) => TagModel.fromJson(tagJson as Map<String, dynamic>)).toList();
  }

  // 🚀 CONSTRUCTOR DE FÁBRICA OFICIAL (El que usa tu Data Source)
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      // ⚠️ Usamos 'id' o 'professionalId' según lo que devuelva tu API. 
      // Si tu API usa 'professionalId', ajusta aquí:
      id: json['professionalId'] as String? ?? (json['id'] as String? ?? '0'), 
      
      starRating: (json['rating'] ?? json['starRating'] ?? 0).toDouble(),
      professionalLevel: json['level'] ?? json['professionalLevel'] ?? 'N/A',
      nombres: json['nombres'] ?? 'Nombre Desconocido',
      apellidos: json['apellidos'] ?? 'Apellido Desconocido',
      availableBalance: (json['availableBalance'] ?? 0.0).toDouble(),
      fotoPerfilUrl: json['fotoPerfilUrl'] as String? ?? '', // URL no puede ser null
      tags: _mapTags(json['tags'] as List<dynamic>?), 
    );
  }
  
}
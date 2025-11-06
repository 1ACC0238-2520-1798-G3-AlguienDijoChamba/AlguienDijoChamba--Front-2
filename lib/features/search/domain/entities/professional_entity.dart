import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import 'package:equatable/equatable.dart';

class ProfessionalEntity extends Equatable {
  final String id;
  final String nombres;
  final String apellidos;
  final String professionalLevel;
  final double starRating;
  final double availableBalance;
  final String fotoPerfilUrl;
  
  // 🚀 CAMBIO CRUCIAL: Añadimos la lista de tags
  final List<TagEntity> tags; 

  const ProfessionalEntity({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.professionalLevel,
    required this.starRating,
    required this.availableBalance,
    required this.fotoPerfilUrl,
    // 🚀 Incluimos Tags en el constructor
    this.tags = const [], 
  });

  // ------------------------------------------
  // 🚀 CONSTRUCTOR DE FÁBRICA (fromJson)
  // ------------------------------------------
  factory ProfessionalEntity.fromJson(Map<String, dynamic> json) {
    // Función auxiliar para mapear la lista de JSON a List<TagEntity>
    final List<TagEntity> mappedTags = (json['tags'] as List<dynamic>?)
        ?.map((tagJson) => TagEntity.fromJson(tagJson as Map<String, dynamic>))
        .toList() ?? const [];

    return ProfessionalEntity(
      // Usamos el operador ?? para manejar posibles nulos o valores por defecto si la API falla.
      id: (json['id'] ?? json['professionalId']) as String, // Acepta 'id' o 'professionalId'
      nombres: json['nombres'] as String? ?? 'N/A',
      apellidos: json['apellidos'] as String? ?? 'N/A',
      professionalLevel: json['professionalLevel'] as String? ?? 'Básico',
      // Convertir a double de forma segura
      starRating: (json['starRating'] as num? ?? 0.0).toDouble(), 
      availableBalance: (json['availableBalance'] as num? ?? 0.0).toDouble(),
      fotoPerfilUrl: json['fotoPerfilUrl'] as String? ?? '',
      tags: mappedTags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombres,
        apellidos,
        professionalLevel,
        starRating,
        availableBalance,
        fotoPerfilUrl,
        tags, // Incluir tags en props
      ];
}
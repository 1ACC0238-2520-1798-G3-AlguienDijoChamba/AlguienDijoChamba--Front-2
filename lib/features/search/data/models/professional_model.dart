import '../../domain/entities/professional_entity.dart';

class ProfessionalModel extends ProfessionalEntity {
  const ProfessionalModel({
    required super.nombres,
    required super.apellidos,
    required super.professionalLevel,
    required super.starRating,
    required super.availableBalance,
    super.fotoPerfilUrl,
    super.professionalId,
  });

  // 1. Constructor original
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      nombres: json['nombres'] ?? 'Nombre No Disponible',
      apellidos: json['apellidos'] ?? 'Apellido No Disponible',
      professionalLevel: json['professionalLevel'] ?? '',
      starRating: (json['starRating'] ?? 0).toDouble(),
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
      fotoPerfilUrl: json['fotoPerfilUrl'],
      professionalId: json['id'],
    );
  }
  
  // 2. 🚨 CORRECCIÓN CLAVE: Eliminamos el placeholder y buscamos los campos de nombre
  factory ProfessionalModel.fromReputationJson(Map<String, dynamic> json) {
    // Si el backend te está enviando 'nombres' y 'apellidos', DEBEN estar aquí.
    return ProfessionalModel(
      // Campos de ID y Métrica:
      professionalId: json['professionalId'] as String,
      starRating: (json['rating'] ?? 0).toDouble(),
      professionalLevel: json['level'] ?? 'N/A',
      // 🚨 CORRECCIÓN: Buscamos el nombre y apellido real (si existen en el JSON de reputación)
      nombres: json['nombres'] ?? 'Nombre Desconocido', 
      apellidos: json['apellidos'] ?? 'Apellido Desconocido',
      availableBalance: 0.0,
      fotoPerfilUrl: null,
    );
  }
}
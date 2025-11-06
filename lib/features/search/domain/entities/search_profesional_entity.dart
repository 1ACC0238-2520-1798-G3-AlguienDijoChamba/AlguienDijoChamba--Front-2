// Archivo: searched_professional_entity.dart
import 'package:equatable/equatable.dart';

class SearchedProfessionalEntity extends Equatable {
  final String professionalId;
  final String? userName;           // Nombre (del Perfil)
  final double starRating;          // Rating (de Reputación)
  final int completedJobs;          // Jobs (de Reputación)
  final String professionalLevel;   // Nivel (de Reputación)
  final double hourlyRate;          // Tarifa (de Reputación)
  final String? profilePhotoUrl;    // Foto (del Perfil)

  // 1. CONSTRUCTOR
  const SearchedProfessionalEntity({
    required this.professionalId,
    this.userName,
    required this.starRating,
    required this.completedJobs,
    required this.professionalLevel,
    required this.hourlyRate,
    this.profilePhotoUrl,
  });

  // 2. FÁBRICA CLAVE para UNIR los datos
  factory SearchedProfessionalEntity.fromCombinedJson({
    required Map<String, dynamic> reputationJson,
    required Map<String, dynamic> profileJson,
  }) {
    // La lógica de combinación usa los campos correctos de cada JSON.
    return SearchedProfessionalEntity(
      // Campos de Reputación
      professionalId: reputationJson['professionalId'] as String,
      starRating: (reputationJson['starRating'] as num? ?? 0.0).toDouble(),
      completedJobs: reputationJson['completedJobs'] as int? ?? 0,
      professionalLevel: reputationJson['professionalLevel'] as String? ?? 'Básico',
      hourlyRate: (reputationJson['hourlyRate'] as num? ?? 0.0).toDouble(),
      
      // Campos de Perfil (que contienen el nombre y la foto)
      userName: profileJson['userName'] as String?,
      // Asegúrate que tu API usa 'fotoPerfilUrl' o cámbialo si usa 'profilePhotoUrl'
      profilePhotoUrl: profileJson['fotoPerfilUrl'] as String?,
    );
  }
  
  // 3. PROPS de Equatable
  @override
  List<Object?> get props => [
        professionalId,
        userName,
        starRating,
        completedJobs,
        professionalLevel,
        hourlyRate,
        profilePhotoUrl,
      ];
}
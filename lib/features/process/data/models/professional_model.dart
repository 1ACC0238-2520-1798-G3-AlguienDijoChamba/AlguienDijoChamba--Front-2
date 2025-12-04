import '../../domain/entities/professional.dart';

class ProfessionalModel extends Professional {
  ProfessionalModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.gender,
    required super.rating,
    required super.reviewCount,
    required super.distance,
    required super.profileImage,
    required super.badgeLevel,
    required super.specialties,
    required super.availability,
    required super.hourlyRate,
  });

  /// Mapear desde JSON del backend
  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    // Extraer nombre completo
    final fullName = json['userName'] as String? ?? 
                     '${json['nombres'] ?? ''} ${json['apellidos'] ?? ''}'.trim();

    // Extraer nivel de profesional (Bronze, Silver, Gold, etc.)
    final badgeLevel = _extractBadgeLevel(json['professionalLevel'] as String? ?? '');

    // Extraer rating (starRating en backend)
    final rating = (json['starRating'] ?? 0).toDouble();

    // Extraer número de reviews (usamos completedJobs como proxy)
    final reviewCount = (json['completedJobs'] ?? 0) as int;

    return ProfessionalModel(
      id: json['id']?.toString() ?? 'unknown',
      fullName: fullName,
      email: json['email'] as String? ?? '',
      phoneNumber: json['celular'] as String? ?? '', // Mapear 'celular' a 'phoneNumber'
      gender: json['genero'] as String? ?? 'Not specified',
      rating: rating,
      reviewCount: reviewCount,
      distance: (json['distance'] ?? 0.5).toDouble(), // Default si no viene
      profileImage: json['fotoPerfilUrl'] as String? ?? '', // Puede ser null
      badgeLevel: badgeLevel,
      specialties: json['specialties'] as List<String>? ?? [], // O extraer de ocupacion
      availability: _buildAvailability(), // Datos estáticos por ahora
      hourlyRate: (json['hourlyRate'] ?? 75.0).toDouble(),
    );
  }

  /// Extraer el badge level de "Bronze Professional" → "Bronze"
  static String _extractBadgeLevel(String professionalLevel) {
    if (professionalLevel.isEmpty) return 'Bronze';
    
    // Si contiene "Bronze", "Silver", "Gold", "Platinum"
    if (professionalLevel.contains('Bronze')) return 'Bronze';
    if (professionalLevel.contains('Silver')) return 'Silver';
    if (professionalLevel.contains('Gold')) return 'Gold';
    if (professionalLevel.contains('Platinum')) return 'Platinum';
    
    return 'Bronze'; // Default
  }

  /// Construir disponibilidad (datos estáticos)
  static Map<String, bool> _buildAvailability() {
    return {
      'Monday': true,
      'Tuesday': true,
      'Wednesday': true,
      'Thursday': true,
      'Friday': true,
      'Saturday': true,
      'Sunday': true,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'rating': rating,
      'reviewCount': reviewCount,
      'distance': distance,
      'profileImage': profileImage,
      'badgeLevel': badgeLevel,
      'specialties': specialties,
      'availability': availability,
      'hourlyRate': hourlyRate,
    };
  }

  factory ProfessionalModel.mock() {
    return ProfessionalModel(
      id: '1',
      fullName: 'Jose Ricardo Martinez Rojas',
      email: 'joseitoMalincito2054@gmail.com',
      phoneNumber: '+51 915 856 521',
      gender: 'Male',
      rating: 4.7,
      reviewCount: 156,
      distance: 0.5,
      profileImage: 'https://via.placeholder.com/150',
      badgeLevel: 'Bronze',
      specialties: ['Handyman', 'Repairs', 'Maintenance'],
      availability: {
        'Monday': true,
        'Tuesday': true,
        'Wednesday': true,
        'Thursday': true,
        'Friday': true,
        'Saturday': true,
        'Sunday': true,
      },
      hourlyRate: 75.0,
    );
  }
}

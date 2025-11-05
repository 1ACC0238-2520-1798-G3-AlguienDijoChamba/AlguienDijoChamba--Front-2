class ProfessionalEntity {
  final String nombres;
  final String apellidos;
  final String? fotoPerfilUrl;
  final String professionalLevel;
  final double starRating;
  final double availableBalance;
  final String? professionalId;
  const ProfessionalEntity({
    required this.nombres,
    required this.apellidos,
    required this.professionalLevel,
    required this.starRating,
    required this.availableBalance,
    this.fotoPerfilUrl,
    this.professionalId,
  });
}

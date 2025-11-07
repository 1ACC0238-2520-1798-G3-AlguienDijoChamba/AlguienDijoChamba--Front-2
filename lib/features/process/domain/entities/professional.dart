class Professional {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final double rating;
  final int reviewCount;
  final double distance;
  final String profileImage;
  final String badgeLevel;
  final List<String> specialties;
  final Map<String, bool> availability;
  final double hourlyRate;

  Professional({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.profileImage,
    required this.badgeLevel,
    required this.specialties,
    required this.availability,
    required this.hourlyRate,
  });
}

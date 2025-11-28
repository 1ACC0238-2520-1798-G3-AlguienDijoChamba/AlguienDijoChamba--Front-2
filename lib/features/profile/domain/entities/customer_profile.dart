class CustomerProfile {
  final String id;
  final String userId;
  final String nombres;
  final String apellidos;
  final String celular;
  final String? photoUrl;
  final String preferredPaymentMethod;
  final bool acceptsBookingUpdates;
  final bool acceptsPromotionsAndOffers;
  final bool acceptsNewsletter;

  CustomerProfile({
    required this.id,
    required this.userId,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    this.photoUrl,
    required this.preferredPaymentMethod,
    required this.acceptsBookingUpdates,
    required this.acceptsPromotionsAndOffers,
    required this.acceptsNewsletter,
  });
}

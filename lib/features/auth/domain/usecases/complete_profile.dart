import '../repositories/auth_repository.dart';

class CompleteProfile {
  final AuthRepository repository;

  CompleteProfile(this.repository);

  Future<void> call({
    required String customerId,
    required int preferredPaymentMethod,
    required bool acceptsBookingUpdates,
    required bool acceptsPromotionsAndOffers,
    required bool acceptsNewsletter,
  }) {
    return repository.completeProfile(
      customerId: customerId,
      preferredPaymentMethod: preferredPaymentMethod,
      acceptsBookingUpdates: acceptsBookingUpdates,
      acceptsPromotionsAndOffers: acceptsPromotionsAndOffers,
      acceptsNewsletter: acceptsNewsletter,
    );
  }
}
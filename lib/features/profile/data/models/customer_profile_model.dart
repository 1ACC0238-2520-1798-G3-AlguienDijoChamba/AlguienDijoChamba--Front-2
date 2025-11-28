// Puedes extender con métodos fromJson/toJson para mapear el DTO
import 'package:alguiendijochamba_app_flutter/features/profile/domain/entities/customer_profile.dart';

class CustomerProfileModel extends CustomerProfile {
  CustomerProfileModel({
    required super.id,
    required super.userId,
    required super.nombres,
    required super.apellidos,
    required super.celular,
    super.photoUrl,
    required super.preferredPaymentMethod,
    required super.acceptsBookingUpdates,
    required super.acceptsPromotionsAndOffers,
    required super.acceptsNewsletter,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      id: json['id'],
      userId: json['userId'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      celular: json['celular'],
      photoUrl: json['photoUrl'],
      preferredPaymentMethod: json['preferredPaymentMethod'] ?? 'None',
      acceptsBookingUpdates: json['acceptsBookingUpdates'],
      acceptsPromotionsAndOffers: json['acceptsPromotionsAndOffers'],
      acceptsNewsletter: json['acceptsNewsletter'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'nombres': nombres,
    'apellidos': apellidos,
    'celular': celular,
    'photoUrl': photoUrl,
    'preferredPaymentMethod': preferredPaymentMethod,
    'acceptsBookingUpdates': acceptsBookingUpdates,
    'acceptsPromotionsAndOffers': acceptsPromotionsAndOffers,
    'acceptsNewsletter': acceptsNewsletter,
  };
}

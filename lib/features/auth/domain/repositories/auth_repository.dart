import 'dart:io';

import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Session> login(String email, String password);
  Future<User> register({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String celular,
  });
  
  Future<void> saveCurrentUserId(String id);
  Future<String?> getCurrentUserId();

  Future<void> completeProfile({
    required String customerId,
    required int preferredPaymentMethod,
    required bool acceptsBookingUpdates,
    required bool acceptsPromotionsAndOffers,
    required bool acceptsNewsletter,
  });
  Future<String> uploadProfilePhoto({
      required String customerId,
      required File photoFile,
    });

}
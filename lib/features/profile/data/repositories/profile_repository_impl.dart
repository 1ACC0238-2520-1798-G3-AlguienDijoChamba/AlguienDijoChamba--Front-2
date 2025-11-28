import 'package:flutter/foundation.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/data/models/customer_profile_model.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/repositories/profile_repository.dart';
import '../../domain/entities/customer_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  
  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerProfile> getProfile(String userId) async {
    try {
      debugPrint('📦 PROFILE REPO: Obteniendo perfil para userId: $userId');
      
      // ✅ Llamar al método correcto: getCustomerProfile
      final data = await remoteDataSource.getCustomerProfile(userId);
      
      debugPrint('📦 PROFILE REPO: Datos recibidos. Convirtiendo a modelo...');
      final profile = CustomerProfileModel.fromJson(data);
      
      debugPrint('✅ PROFILE REPO: Perfil obtenido exitosamente');
      return profile;
    } catch (e) {
      debugPrint('❌ PROFILE REPO ERROR en getProfile: $e');
      rethrow;
    }
  }

@override
Future<void> updateProfile(String customerId, CustomerProfile profile) async {
  try {
    debugPrint('📦 PROFILE REPO: Actualizando perfil para customerId: $customerId');
    
    // ✅ Convertir preferredPaymentMethod string a int
    int paymentMethodInt = _paymentMethodStringToInt(profile.preferredPaymentMethod);
    
    final profileJson = {
      'nombres': profile.nombres,
      'apellidos': profile.apellidos,
      'celular': profile.celular,
      'photoUrl': profile.photoUrl ?? '',
      'preferredPaymentMethod': paymentMethodInt,  // ✅ Enviar int
      'acceptsBookingUpdates': profile.acceptsBookingUpdates,
      'acceptsPromotionsAndOffers': profile.acceptsPromotionsAndOffers,
      'acceptsNewsletter': profile.acceptsNewsletter,
    };
    
    debugPrint('📦 PROFILE REPO: JSON a enviar: $profileJson');
    
    await remoteDataSource.updateCustomerProfile(customerId, profileJson);
    
    debugPrint('✅ PROFILE REPO: Perfil actualizado exitosamente');
  } catch (e) {
    debugPrint('❌ PROFILE REPO ERROR en updateProfile: $e');
    rethrow;
  }
}

// ✅ Helper para convertir
int _paymentMethodStringToInt(String method) {
  switch (method.toLowerCase()) {
    case 'credit card':
    case 'debit card':
    case 'credit/debit card':
    case 'card':
      return 0;
    case 'digital wallet':
    case 'wallet':
      return 1;
    default:
      return 0;
  }
}
}

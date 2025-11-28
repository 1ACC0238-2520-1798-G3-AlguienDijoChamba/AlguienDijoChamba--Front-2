import '../entities/customer_profile.dart';

abstract class ProfileRepository {
  Future<CustomerProfile> getProfile(String userId);
  Future<void> updateProfile(String customerId, CustomerProfile profile);
}

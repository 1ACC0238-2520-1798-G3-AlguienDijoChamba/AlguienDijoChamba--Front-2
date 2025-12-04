import '../entities/customer_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;
  
  UpdateProfile(this.repository);

  Future<void> call(String customerId, CustomerProfile profile) =>
      repository.updateProfile(customerId, profile);
}

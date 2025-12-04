import '../entities/customer_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;
  
  GetProfile(this.repository);

  Future<CustomerProfile> call(String userId) => repository.getProfile(userId);
}

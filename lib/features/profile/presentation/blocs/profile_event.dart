import '../../domain/entities/customer_profile.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;
  LoadProfile(this.userId);
}

class EditProfileNavigate extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String customerId;
  final CustomerProfile updatedProfile;
  UpdateProfileEvent(this.customerId, this.updatedProfile);
}

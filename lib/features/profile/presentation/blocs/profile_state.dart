import '../../domain/entities/customer_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final CustomerProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final CustomerProfile profile;
  ProfileUpdated(this.profile);
}

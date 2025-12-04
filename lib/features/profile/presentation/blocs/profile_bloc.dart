import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
  }) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfile(event.userId);
        emit(ProfileLoaded(profile));
        print('✅ PROFILE BLOC: Perfil cargado correctamente');
      } catch (e) {
        print('❌ PROFILE BLOC ERROR: ${e.toString()}');
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileUpdating());
      try {
        await updateProfile(event.customerId, event.updatedProfile);
        emit(ProfileUpdated(event.updatedProfile));
        print('✅ PROFILE BLOC: Perfil actualizado correctamente');
        // Recarga el perfil después de actualizar
        add(LoadProfile(event.updatedProfile.userId));
      } catch (e) {
        print('❌ PROFILE BLOC ERROR al actualizar: ${e.toString()}');
        emit(ProfileError(e.toString()));
      }
    });
  }
}

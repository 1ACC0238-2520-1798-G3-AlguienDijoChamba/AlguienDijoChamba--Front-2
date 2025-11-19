import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/complete_profile.dart';

// --- Events ---
abstract class CompleteProfileEvent {}

class SubmitCompleteProfileEvent extends CompleteProfileEvent {
  final String customerId;
  final int preferredPaymentMethod;
  final bool acceptsBookingUpdates;
  final bool acceptsPromotionsAndOffers;
  final bool acceptsNewsletter;

  SubmitCompleteProfileEvent({
    required this.customerId,
    required this.preferredPaymentMethod,
    required this.acceptsBookingUpdates,
    required this.acceptsPromotionsAndOffers,
    required this.acceptsNewsletter,
  });
}

// --- States ---
abstract class CompleteProfileState {}
class CompleteProfileInitial extends CompleteProfileState {}
class CompleteProfileLoading extends CompleteProfileState {}
class CompleteProfileSuccess extends CompleteProfileState {} // Éxito
class CompleteProfileFailure extends CompleteProfileState {
  final String error;
  CompleteProfileFailure(this.error);
}

// --- BLoC ---
class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final CompleteProfile completeProfile;

  CompleteProfileBloc({required this.completeProfile}) : super(CompleteProfileInitial()) {
    on<SubmitCompleteProfileEvent>((event, emit) async {
      emit(CompleteProfileLoading());
      try {
        // Llama al Use Case
        await completeProfile(
          customerId: event.customerId,
          preferredPaymentMethod: event.preferredPaymentMethod,
          acceptsBookingUpdates: event.acceptsBookingUpdates,
          acceptsPromotionsAndOffers: event.acceptsPromotionsAndOffers,
          acceptsNewsletter: event.acceptsNewsletter,
        );
        emit(CompleteProfileSuccess());
      } catch (e) {
        emit(CompleteProfileFailure(e.toString()));
      }
    });
  }
}
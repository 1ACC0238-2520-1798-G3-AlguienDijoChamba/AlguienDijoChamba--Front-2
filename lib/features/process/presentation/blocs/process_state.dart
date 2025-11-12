// lib/features/process/presentation/blocs/process_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/payment.dart';


abstract class ProcessState extends Equatable {
  const ProcessState();

  @override
  List<Object?> get props => [];
}

class ProcessInitial extends ProcessState {
  const ProcessInitial();
}

class ProcessLoading extends ProcessState {
  const ProcessLoading();
}

class ProcessError extends ProcessState {
  final String message;

  const ProcessError(this.message);

  @override
  List<Object?> get props => [message];
}

// ✨ Estados para Profesionales
class ProfessionalLoaded extends ProcessState {
  final Professional professional;

  const ProfessionalLoaded(this.professional);

  @override
  List<Object?> get props => [professional];
}

// ✨ Estados para Jobs
class JobCreated extends ProcessState {
  final Job job;

  const JobCreated(this.job);

  @override
  List<Object?> get props => [job];
}

class JobCompleted extends ProcessState {
  const JobCompleted();
}

class JobCancelled extends ProcessState {
  const JobCancelled();
}

class JobAcceptedShowPayment extends ProcessState {
  final String jobId;
  final String professionalId;
  final double proposedCost;

  const JobAcceptedShowPayment({
    required this.jobId,
    required this.professionalId,
    required this.proposedCost,
  });

  @override
  List<Object?> get props => [jobId, professionalId, proposedCost];
}

// ✨ Estados para SignalR - Notificaciones de técnicos
class JobAcceptedByTechnician extends ProcessState {
  final String jobId;

  const JobAcceptedByTechnician(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobDeclinedByTechnician extends ProcessState {
  final String jobId;

  const JobDeclinedByTechnician(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

// ✨ Estados para Pagos
class PaymentProcessed extends ProcessState {
  final Payment payment;

  const PaymentProcessed(this.payment);

  @override
  List<Object?> get props => [payment];
}

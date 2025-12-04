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

// 🔹 NUEVO: lista de jobs disponibles
class JobsLoaded extends ProcessState {
  final List<Job> jobs;

  const JobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

// ✨ Estados para Pagos
class PaymentProcessed extends ProcessState {
  final Payment payment;

  const PaymentProcessed(this.payment);

  @override
  List<Object?> get props => [payment];
}

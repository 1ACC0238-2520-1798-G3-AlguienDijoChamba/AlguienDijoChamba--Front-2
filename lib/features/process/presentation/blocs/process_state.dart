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

class ProcessInitial extends ProcessState {}

class ProcessLoading extends ProcessState {}

class ProfessionalLoaded extends ProcessState {
  final Professional professional;

  const ProfessionalLoaded(this.professional);

  @override
  List<Object?> get props => [professional];
}

class JobCreated extends ProcessState {
  final Job job;

  const JobCreated(this.job);

  @override
  List<Object?> get props => [job];
}

class PaymentProcessed extends ProcessState {
  final Payment payment;

  const PaymentProcessed(this.payment);

  @override
  List<Object?> get props => [payment];
}

class JobCompleted extends ProcessState {}

class JobCancelled extends ProcessState {}

class ProcessError extends ProcessState {
  final String message;

  const ProcessError(this.message);

  @override
  List<Object?> get props => [message];
}

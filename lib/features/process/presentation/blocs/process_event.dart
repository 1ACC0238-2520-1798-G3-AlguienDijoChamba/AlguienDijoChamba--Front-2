// lib/features/process/presentation/blocs/process_event.dart

import 'package:equatable/equatable.dart';

abstract class ProcessEvent extends Equatable {
  const ProcessEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfessionalDetail extends ProcessEvent {
  final String professionalId;

  const LoadProfessionalDetail(this.professionalId);

  @override
  List<Object?> get props => [professionalId];
}

class CreateJob extends ProcessEvent {
  final Map<String, dynamic> jobData;

  const CreateJob(this.jobData);

  @override
  List<Object?> get props => [jobData];
}

class ProcessJobPayment extends ProcessEvent {
  final Map<String, dynamic> paymentData;

  const ProcessJobPayment(this.paymentData);

  @override
  List<Object?> get props => [paymentData];
}

class FinishJob extends ProcessEvent {
  final String jobId;
  final int rating;
  final String review;

  const FinishJob(this.jobId, this.rating, this.review);

  @override
  List<Object?> get props => [jobId, rating, review];
}

class CancelActiveJob extends ProcessEvent {
  final String jobId;
  final String reason;

  const CancelActiveJob(this.jobId, this.reason);

  @override
  List<Object?> get props => [jobId, reason];
}

// 🔹 NUEVO: cargar lista de jobs
class LoadAvailableJobs extends ProcessEvent {
  const LoadAvailableJobs();
}

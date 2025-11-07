import 'package:flutter_bloc/flutter_bloc.dart';
import 'process_event.dart';
import 'process_state.dart';
import '../../domain/usecases/get_professional_detail.dart';
import '../../domain/usecases/create_job_request.dart';
import '../../domain/usecases/process_payment.dart';
import '../../domain/usecases/complete_job.dart';
import '../../domain/usecases/cancel_job.dart';


class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final GetProfessionalDetail getProfessionalDetail;
  final CreateJobRequest createJobRequest;
  final ProcessPayment processPayment;
  final CompleteJob completeJob;
  final CancelJob cancelJob;

  ProcessBloc({
    required this.getProfessionalDetail,
    required this.createJobRequest,
    required this.processPayment,
    required this.completeJob,
    required this.cancelJob,
  }) : super(ProcessInitial()) {
    on<LoadProfessionalDetail>(_onLoadProfessionalDetail);
    on<CreateJob>(_onCreateJob);
    on<ProcessJobPayment>(_onProcessPayment);
    on<FinishJob>(_onFinishJob);
    on<CancelActiveJob>(_onCancelJob);
  }

  Future<void> _onLoadProfessionalDetail(
    LoadProfessionalDetail event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    final result = await getProfessionalDetail(event.professionalId);
    
    result.fold(
      (failure) => emit(ProcessError(failure.message)),
      (professional) => emit(ProfessionalLoaded(professional)),
    );
  }

  Future<void> _onCreateJob(
    CreateJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    final result = await createJobRequest(event.jobData);
    
    result.fold(
      (failure) => emit(ProcessError(failure.message)),
      (job) => emit(JobCreated(job)),
    );
  }

  Future<void> _onProcessPayment(
    ProcessJobPayment event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    final result = await processPayment(event.paymentData);
    
    result.fold(
      (failure) => emit(ProcessError(failure.message)),
      (payment) => emit(PaymentProcessed(payment)),
    );
  }

  Future<void> _onFinishJob(
    FinishJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    final result = await completeJob(event.jobId, event.rating, event.review);
    
    result.fold(
      (failure) => emit(ProcessError(failure.message)),
      (_) => emit(JobCompleted()),
    );
  }

  Future<void> _onCancelJob(
    CancelActiveJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    final result = await cancelJob(event.jobId, event.reason);
    
    result.fold(
      (failure) => emit(ProcessError(failure.message)),
      (_) => emit(JobCancelled()),
    );
  }
}

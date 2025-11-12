import 'package:flutter_bloc/flutter_bloc.dart';
import 'process_event.dart';
import 'process_state.dart';
import '../../domain/usecases/get_professional_detail.dart';
import '../../domain/usecases/create_job_request.dart';
import '../../domain/usecases/complete_job.dart';
import '../../domain/usecases/cancel_job.dart';


class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final GetProfessionalDetail getProfessionalDetail;
  final CreateJobRequest createJobRequest;
  final CompleteJob completeJob;
  final CancelJob cancelJob;

  ProcessBloc({
    required this.getProfessionalDetail,
    required this.createJobRequest,
    required this.completeJob,
    required this.cancelJob,
  }) : super(ProcessInitial()) {
    on<LoadProfessionalDetail>(_onLoadProfessionalDetail);
    on<CreateJob>(_onCreateJob);
    on<FinishJob>(_onFinishJob);
    on<CancelActiveJob>(_onCancelJob);
  }

  Future<void> _onLoadProfessionalDetail(
    LoadProfessionalDetail event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    print('📄 BLOC: Cargando profesional ${event.professionalId}');

    final result = await getProfessionalDetail(event.professionalId);

    result.fold(
      (failure) {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (professional) {
        print('✅ BLOC: Profesional cargado ${professional.fullName}');
        emit(ProfessionalLoaded(professional));
      },
    );
  }

  Future<void> _onCreateJob(CreateJob event, Emitter<ProcessState> emit) async {
    emit(ProcessLoading());
    print('📝 BLOC: Creando job con datos: ${event.jobData}');

    final result = await createJobRequest(event.jobData);

    result.fold(
      (failure) {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (job) {
        print('✅ BLOC: JOB CREADO');
        print('   - ID: ${job.id}');
        print('   - Professional: ${job.professionalId}');
        print('   - Address: ${job.address}');
        emit(JobCreated(job));
      },
    );
  }
Future<void> _onFinishJob(FinishJob event, Emitter<ProcessState> emit) async {
  emit(ProcessLoading());
  print('🏁 BLOC: Completando job ${event.jobId}');

  final result = await completeJob(event.jobId, event.rating, event.review);

  result.fold(
    (failure) {
      print('❌ BLOC ERROR: ${failure.toString()}');
      emit(ProcessError(failure.toString()));
    },
    (_) {
      print('✅ BLOC: JOB COMPLETADO');
      emit(JobCompleted());
    },
  );
}


  Future<void> _onCancelJob(
    CancelActiveJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(ProcessLoading());
    print('🚫 BLOC: Cancelando job ${event.jobId}');

    final result = await cancelJob(event.jobId, event.reason);

    result.fold(
      (failure) {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (_) {
        print('✅ BLOC: JOB CANCELADO');
        emit(JobCancelled());
      },
    );
  }
    Future<void> _onJobStatusUpdatedByHub(
    JobStatusUpdatedByHub event,
    Emitter<ProcessState> emit,
  ) async {
    print('SignalR BLoC: Recibido JobId: ${event.jobId} con estado: ${event.status}');
    
    if (event.status == "Accepted") {
      // 🚀 EMITE EL NUEVO ESTADO CON EL COSTO
      emit(JobAcceptedShowPayment(
        jobId: event.jobId,
        professionalId: event.professionalId ?? 'unknown',
        proposedCost: event.proposedCost ?? 0.0
      ));
    } else if (event.status == "Declined") {
      emit(JobDeclinedByTechnician(event.jobId));
    } 
  }
}

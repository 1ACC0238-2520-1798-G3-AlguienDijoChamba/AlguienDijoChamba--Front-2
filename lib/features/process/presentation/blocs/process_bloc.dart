// lib/features/process/presentation/blocs/process_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'process_event.dart';
import 'process_state.dart';
import '../../domain/usecases/get_professional_detail.dart';
import '../../domain/usecases/create_job_request.dart';
import '../../domain/usecases/complete_job.dart';
import '../../domain/usecases/cancel_job.dart';
import '../../domain/repositories/process_repository.dart';

class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final GetProfessionalDetail getProfessionalDetail;
  final CreateJobRequest createJobRequest;
  final CompleteJob completeJob;
  final CancelJob cancelJob;
  final ProcessRepository repository; // 🔹 para getAvailableJobs()

  ProcessBloc({
    required this.getProfessionalDetail,
    required this.createJobRequest,
    required this.completeJob,
    required this.cancelJob,
    required this.repository,
  }) : super(const ProcessInitial()) {
    on<LoadProfessionalDetail>(_onLoadProfessionalDetail);
    on<CreateJob>(_onCreateJob);
    on<FinishJob>(_onFinishJob);
    on<CancelActiveJob>(_onCancelJob);
    on<LoadAvailableJobs>(_onLoadAvailableJobs); // 🔹 nuevo
  }

  Future<void> _onLoadProfessionalDetail(
    LoadProfessionalDetail event,
    Emitter<ProcessState> emit,
  ) async {
    emit(const ProcessLoading());
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

  Future<void> _onCreateJob(
    CreateJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(const ProcessLoading());
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

  Future<void> _onFinishJob(
    FinishJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(const ProcessLoading());
    print('🏁 BLOC: Completando job ${event.jobId}');

    final result = await completeJob(event.jobId, event.rating, event.review);

    await result.fold(
      (failure) async {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (_) async {
        print('✅ BLOC: JOB COMPLETADO');
        emit(const JobCompleted());

        // 🔁 recargar lista de jobs después de completar
        print('DEBUG BLOC: recargando jobs después de JobCompleted');
        final jobsResult = await repository.getAvailableJobs();
        jobsResult.fold(
          (f) {
            print('❌ BLOC ERROR recarga: ${f.toString()}');
            emit(ProcessError(f.toString()));
          },
          (jobs) {
            print('DEBUG BLOC: recarga -> ${jobs.length} jobs');
            emit(JobsLoaded(jobs));
          },
        );
      },
    );
  }

  Future<void> _onCancelJob(
    CancelActiveJob event,
    Emitter<ProcessState> emit,
  ) async {
    emit(const ProcessLoading());
    print('🚫 BLOC: Cancelando job ${event.jobId}');

    final result = await cancelJob(event.jobId, event.reason);

    await result.fold(
      (failure) async {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (_) async {
        print('✅ BLOC: JOB CANCELADO');
        emit(const JobCancelled());

        // 🔁 recargar lista de jobs después de cancelar
        print('DEBUG BLOC: recargando jobs después de JobCancelled');
        final jobsResult = await repository.getAvailableJobs();
        jobsResult.fold(
          (f) {
            print('❌ BLOC ERROR recarga: ${f.toString()}');
            emit(ProcessError(f.toString()));
          },
          (jobs) {
            print('DEBUG BLOC: recarga -> ${jobs.length} jobs');
            emit(JobsLoaded(jobs));
          },
        );
      },
    );
  }

  // 🔹 NUEVO: cargar lista de jobs desde repository.getAvailableJobs()
  Future<void> _onLoadAvailableJobs(
    LoadAvailableJobs event,
    Emitter<ProcessState> emit,
  ) async {
    print('DEBUG BLOC: LoadAvailableJobs recibido'); // 👈 NUEVO

    emit(const ProcessLoading());
    print('📋 BLOC: Cargando lista de jobs disponibles');

    final result = await repository.getAvailableJobs();

    result.fold(
      (failure) {
        print('❌ BLOC ERROR: ${failure.toString()}');
        emit(ProcessError(failure.toString()));
      },
      (jobs) {
        print('DEBUG BLOC: LoadAvailableJobs -> ${jobs.length} jobs'); // 👈 NUEVO
        print('✅ BLOC: Jobs cargados (${jobs.length})');
        emit(JobsLoaded(jobs));
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

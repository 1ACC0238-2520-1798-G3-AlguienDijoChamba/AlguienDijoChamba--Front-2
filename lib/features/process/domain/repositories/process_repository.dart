// lib/features/process/domain/repositories/process_repository.dart

import 'package:dartz/dartz.dart';
import 'package:alguiendijochamba_app_flutter/core/error/failures.dart';
import '../entities/professional.dart';
import '../entities/job.dart';

abstract class ProcessRepository {
  Future<Either<Failure, Professional>> getProfessionalDetail(String professionalId);
  Future<Either<Failure, Job>> createJobRequest(Map<String, dynamic> params);
  Future<Either<Failure, List<Job>>> getAvailableJobs();  // ✨ NUEVO
  Future<Either<Failure, Job>> saveActiveJob(Map<String, dynamic> jobData);
  Future<Either<Failure, Job?>> getActiveJob(String clientId);
  Future<Either<Failure, void>> updateJobStatus(String jobId, String status);
  Future<Either<Failure, Job>> getJobById(String jobId);  // ✨ NUEVO
  Future<Either<Failure, void>> completeJob(String jobId, int rating, String review);
  Future<Either<Failure, void>> cancelJob(String jobId, String reason);
}

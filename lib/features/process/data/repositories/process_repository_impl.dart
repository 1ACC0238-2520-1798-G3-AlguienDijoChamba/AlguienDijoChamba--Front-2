// lib/features/process/data/repositories/process_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:alguiendijochamba_app_flutter/core/error/failures.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/process_repository.dart';
import '../datasources/process_remote_data_source.dart';

class ProcessRepositoryImpl implements ProcessRepository {
  final ProcessRemoteDataSource remoteDataSource;

  ProcessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Professional>> getProfessionalDetail(String professionalId) async {
    try {
      final professional = await remoteDataSource.getProfessionalById(professionalId);
      return Right(professional);
    } catch (e) {
      return Left(ServerFailure('Failed to load professional: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Job>> createJobRequest(Map<String, dynamic> params) async {
    try {
      final jobModel = await remoteDataSource.createJobRequest(params);
      return Right(jobModel);
    } catch (e) {
      return Left(ServerFailure('Failed to create job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getAvailableJobs() async {
    try {
      final jobs = await remoteDataSource.getAvailableJobs();
      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch available jobs: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Job>> saveActiveJob(Map<String, dynamic> jobData) async {
    try {
      final jobModel = await remoteDataSource.saveActiveJob(jobData);
      return Right(jobModel);
    } catch (e) {
      return Left(ServerFailure('Failed to save active job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Job?>> getActiveJob(String clientId) async {
    try {
      final jobModel = await remoteDataSource.getActiveJob(clientId);
      return Right(jobModel);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch active job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateJobStatus(String jobId, String status) async {
    try {
      await remoteDataSource.updateJobStatus(jobId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update job status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Job>> getJobById(String jobId) async {
    try {
      final jobModel = await remoteDataSource.getJobById(jobId);
      return Right(jobModel);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> completeJob(String jobId, int rating, String review) async {
    try {
      await remoteDataSource.completeJob(jobId, rating, review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to complete job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelJob(String jobId, String reason) async {
    try {
      await remoteDataSource.cancelJob(jobId, reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to cancel job: ${e.toString()}'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:alguiendijochamba_app_flutter/core/error/failures.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../../domain/entities/payment.dart';
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
      final job = await remoteDataSource.createJobRequest(params);
      return Right(job);
    } catch (e) {
      return Left(ServerFailure('Failed to create job: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Payment>> processPayment(Map<String, dynamic> params) async {
    try {
      final payment = await remoteDataSource.processPayment(params);
      return Right(payment);
    } catch (e) {
      return Left(ServerFailure('Failed to process payment: ${e.toString()}'));
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

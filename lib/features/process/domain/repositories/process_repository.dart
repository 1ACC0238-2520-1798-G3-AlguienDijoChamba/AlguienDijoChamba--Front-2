import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/professional.dart';
import '../entities/job.dart';
import '../entities/payment.dart';

abstract class ProcessRepository {
  Future<Either<Failure, Professional>> getProfessionalDetail(String professionalId);
  Future<Either<Failure, Job>> createJobRequest(Map<String, dynamic> params);
  Future<Either<Failure, Payment>> processPayment(Map<String, dynamic> params);
  Future<Either<Failure, void>> completeJob(String jobId, int rating, String review);
  Future<Either<Failure, void>> cancelJob(String jobId, String reason);
}

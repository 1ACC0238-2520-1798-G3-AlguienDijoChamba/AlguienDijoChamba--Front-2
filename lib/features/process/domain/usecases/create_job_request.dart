import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/job.dart';
import '../repositories/process_repository.dart';

class CreateJobRequest {
  final ProcessRepository repository;

  CreateJobRequest(this.repository);

  Future<Either<Failure, Job>> call(Map<String, dynamic> params) async {
    return await repository.createJobRequest(params);
  }
}

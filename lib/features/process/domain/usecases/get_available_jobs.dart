import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/job.dart';
import '../repositories/process_repository.dart';

class GetAvailableJobs {
  final ProcessRepository repository;
  GetAvailableJobs(this.repository);

  Future<Either<Failure, List<Job>>> call() {
    return repository.getAvailableJobs();
  }
}

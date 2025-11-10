import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/process_repository.dart';

class CompleteJob {
  final ProcessRepository repository;

  CompleteJob(this.repository);

  Future<Either<Failure, void>> call(String jobId, int rating, String review) async {
    return await repository.completeJob(jobId, rating, review);
  }
}

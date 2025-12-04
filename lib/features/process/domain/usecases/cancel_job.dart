import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/process_repository.dart';

class CancelJob {
  final ProcessRepository repository;

  CancelJob(this.repository);

  Future<Either<Failure, void>> call(String jobId, String reason) async {
    return await repository.cancelJob(jobId, reason);
  }
}

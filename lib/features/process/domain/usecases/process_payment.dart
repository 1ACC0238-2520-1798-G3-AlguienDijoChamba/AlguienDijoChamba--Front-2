import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../repositories/process_repository.dart';

class ProcessPayment {
  final ProcessRepository repository;

  ProcessPayment(this.repository);

  Future<Either<Failure, Payment>> call(Map<String, dynamic> params) async {
    return await repository.processPayment(params);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/professional.dart';
import '../repositories/process_repository.dart';

class GetProfessionalDetail {
  final ProcessRepository repository;

  GetProfessionalDetail(this.repository);

  Future<Either<Failure, Professional>> call(String professionalId) async {
    return await repository.getProfessionalDetail(professionalId);
  }
}

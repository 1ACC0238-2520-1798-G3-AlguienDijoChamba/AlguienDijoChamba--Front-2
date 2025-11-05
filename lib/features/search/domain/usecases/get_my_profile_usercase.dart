// Archivo: lib/features/professional/domain/usecases/get_my_profile_usecase.dart

import '../entities/professional_entity.dart';
import '../repositories/professional_repository.dart';

// Renombra esta clase a GetProfessionalsListUseCase para mayor claridad
class GetProfessionalsListUseCase { 
  final ProfessionalRepository repository;

  GetProfessionalsListUseCase(this.repository);

  // 🚨 Devuelve una LISTA
  Future<List<ProfessionalEntity>> call() async {
    return await repository.getAllProfessionals();
  }
}
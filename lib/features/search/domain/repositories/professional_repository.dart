// Archivo: lib/features/professional/domain/repositories/professional_repository.dart

import '../entities/professional_entity.dart';

abstract class ProfessionalRepository {
  // 🚨 CORRECCIÓN FINAL EN EL CONTRATO: DEBE DEVOLVER UNA LISTA
  Future<List<ProfessionalEntity>> getAllProfessionals(); 
}
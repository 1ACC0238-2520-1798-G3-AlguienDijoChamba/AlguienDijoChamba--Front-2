// Archivo: lib/features/professional/data/repositories/professional_repository_impl.dart

import '../../domain/entities/professional_entity.dart';
import '../../domain/repositories/professional_repository.dart';
import '../datasources/professional_remote_data_source.dart';

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalRemoteDataSource remoteDataSource;

  ProfessionalRepositoryImpl(this.remoteDataSource);

  @override
  // 🚨 Implementación que llama a la nueva función
  Future<List<ProfessionalEntity>> getAllProfessionals() async {
    return await remoteDataSource.getAllProfessionals();
  }
  
  // El antiguo getMyProfile se elimina o se cambia si es necesario
}
import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';
import '../../domain/repositories/professional_repository.dart';
import '../datasources/professional_remote_data_source.dart';
import '../../domain/repositories/tag_repository.dart'; // Asegúrate de importar esto

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalRemoteDataSource remoteDataSource;
  final TagRepository tagRepository; // ← nuevo

  ProfessionalRepositoryImpl(this.remoteDataSource, this.tagRepository);

  @override
  Future<List<SearchedProfessionalEntity>> searchProfessionals(SearchProfessionalsQuery query) async {
    if (query.tagIds.isEmpty) {
      final List<dynamic> reputationListJson = await remoteDataSource.searchProfessionals(query);
      final hydrationFutures = reputationListJson.map((reputationJson) async {
        final String professionalId = reputationJson['professionalId'] as String;
        final Map<String, dynamic> profileJson = await remoteDataSource.getProfessionalProfileJson(professionalId);
        return SearchedProfessionalEntity.fromCombinedJson(
          reputationJson: reputationJson,
          profileJson: profileJson,
        );
      }).toList();
      return Future.wait(hydrationFutures);
    }

    // Si tiene tags
    final List<String> professionalIds = await tagRepository.getProfessionalIdsByTags(tagIds: query.tagIds);
    if (professionalIds.isEmpty) return [];

    final hydrationFutures = professionalIds.map((professionalId) async {
      final reputationJson = await remoteDataSource.getReputationByProfessionalId(professionalId);
      final profileJson = await remoteDataSource.getProfessionalProfileJson(professionalId);
      return SearchedProfessionalEntity.fromCombinedJson(
        reputationJson: reputationJson,
        profileJson: profileJson,
      );
    }).toList();

    return Future.wait(hydrationFutures);
  }
}

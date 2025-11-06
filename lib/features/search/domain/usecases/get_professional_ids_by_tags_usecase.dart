// Archivo: lib/features/search/domain/usecases/get_professional_ids_by_tags_usecase.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/repositories/tag_repository.dart';

class GetProfessionalIdsByTagsUseCase {
  final TagRepository repository;

  GetProfessionalIdsByTagsUseCase(this.repository);

  // Esta función recibirá la lista de IDs del TagFilterCubit
  Future<List<String>> call({required List<String> tagIds}) async {
    return await repository.getProfessionalIdsByTags(tagIds: tagIds);
  }
}
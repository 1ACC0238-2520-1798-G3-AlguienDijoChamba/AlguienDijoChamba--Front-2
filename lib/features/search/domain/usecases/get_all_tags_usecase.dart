import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/tag_entities.dart';
import '../../domain/repositories/tag_repository.dart';

class GetAllTagsUseCase {
  final TagRepository repository;

  GetAllTagsUseCase(this.repository);

  // La función 'call' ejecuta la acción de obtener los datos
  Future<List<TagEntity>> call() async {
    return await repository.getAllTags();
  }
}
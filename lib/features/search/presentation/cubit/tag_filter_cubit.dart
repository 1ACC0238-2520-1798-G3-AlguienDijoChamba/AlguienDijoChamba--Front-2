import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tag_filter_state.dart';

class TagFilterCubit extends Cubit<TagFilterState> {
  final GetAllTagsUseCase getAllTagsUseCase;
  // 🚫 Eliminamos AssignTagsUseCase y AuthRepository

  TagFilterCubit({
    required this.getAllTagsUseCase,
  }) : super(TagFilterLoading());

  // -----------------------------------------------------
  // A. Carga Inicial del Catálogo
  // -----------------------------------------------------

  Future<void> loadTagCatalog() async {
    emit(TagFilterLoading());
    try {
      // 1. Obtener todo el catálogo de tags disponible (GET /reputation/tags)
      final availableTags = await getAllTagsUseCase();
      
      // 2. Iniciamos sin tags seleccionados
      final currentTags = <String>[]; 

      emit(TagFilterLoaded(
        availableTags: availableTags,
        selectedTagIds: currentTags,
      ));

    } catch (e) {
      emit(TagFilterError('Error al cargar el catálogo de tags para filtrar: ${e.toString()}'));
    }
  }

  // -----------------------------------------------------
  // B. Lógica de Selección (Filtro)
  // -----------------------------------------------------

  void toggleTagSelection(String tagId) {
    if (state is! TagFilterLoaded) return; 

    final currentState = state as TagFilterLoaded;
    final List<String> currentSelected = List.from(currentState.selectedTagIds);

    if (currentSelected.contains(tagId)) {
      currentSelected.remove(tagId);
    } else {
      currentSelected.add(tagId);
    }
    
    // Emitimos el nuevo estado Loaded con la selección de filtro actualizada
    emit(currentState.copyWith(selectedTagIds: currentSelected));
    
    // ⚠️ NOTA: Después de esta llamada, la UI debería notificar al Cubit de Búsqueda
    // principal para ejecutar una nueva búsqueda con estos filtros.
  }
  

  // -----------------------------------------------------
  // C. Getter para la Búsqueda
  // -----------------------------------------------------

  // Este método se puede llamar desde otro Cubit (ej. SearchCubit)
  List<String> getCurrentFilters() {
    if (state is TagFilterLoaded) {
      return (state as TagFilterLoaded).selectedTagIds;
    }
    return [];
  }
}
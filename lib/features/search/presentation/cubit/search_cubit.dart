import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import '../../domain/usecases/search_professionals_usecase.dart';

class SearchCubit extends Cubit<SearchState> {
  // El Use Case ya devuelve List<SearchedProfessionalEntity>
  final SearchProfessionalsUseCase searchProfessionalsUseCase; 
  
  // Parámetros internos de búsqueda y paginación
  // 💡 Mejor práctica: Paginación y filtros deben ser parte del estado interno
  int _page = 1;
  static const int _limit = 10;
  List<String> _currentTagFilters = [];
  
  // 🚀 GETTER CRUCIAL: Necesario para la coordinación en SearchPage
  List<String> get currentTagFilters => _currentTagFilters; 
  
  SearchCubit({
    required this.searchProfessionalsUseCase,
  }) : super(SearchInitial()); // Inicia el estado

  // -----------------------------------------------------
  // A. Búsqueda Principal (Inicial o Filtrada)
  // -----------------------------------------------------

  Future<void> runSearch({List<String>? newTagFilters}) async {
    // Si hay nuevos filtros, reiniciamos la paginación y guardamos los filtros
    if (newTagFilters != null) {
      _currentTagFilters = newTagFilters;
      _page = 1; // 🎯 Reinicia la página al aplicar un nuevo filtro
    } 
    
    // Evita cargas simultáneas
    if (state is SearchLoading) return;
    
    emit(SearchLoading());

    try {
      // 1. Construye la Query con el estado interno
        final query = SearchProfessionalsQuery(
              page: _page,
              limit: _limit,
              // 🔑 Aquí se pasan los filtros de tags seleccionados
              tagIds: _currentTagFilters, 
        );

      // 2. Ejecuta el Use Case (devuelve List<SearchedProfessionalEntity>)
      final newProfessionals = await searchProfessionalsUseCase(query);
      
      final hasMore = newProfessionals.length == _limit;
      
      emit(SearchLoaded(
        professionals: newProfessionals,
        hasMore: hasMore,
      ));

    } catch (e) {
      emit(SearchError(message: 'Error al buscar profesionales: ${e.toString()}'));
    }
  }

  // -----------------------------------------------------
  // B. Paginación (Load More)
  // -----------------------------------------------------

  Future<void> loadMore() async {
    // Solo cargamos si es SearchLoaded y hay más
    if (state is! SearchLoaded || !(state as SearchLoaded).hasMore) return;

    final currentState = state as SearchLoaded;
    _page++; // Avanza a la siguiente página

    // Emitimos el estado de "Cargando Más" manteniendo los resultados actuales
    emit(SearchLoadingMore(
      professionals: currentState.professionals,
      hasMore: currentState.hasMore,
    ));

    try {
      // 1. Construye la Query con la nueva página
      final query = SearchProfessionalsQuery(
        page: _page,
        limit: _limit,
        tagIds: _currentTagFilters, // Mantiene los filtros actuales
      );
      
      // 2. Ejecuta la carga
      final moreProfessionals = await searchProfessionalsUseCase(query);
      
      final hasMore = moreProfessionals.length == _limit;
      
      final updatedList = [...currentState.professionals, ...moreProfessionals];

      emit(SearchLoaded(
        professionals: updatedList,
        hasMore: hasMore,
      ));

    } catch (e) {
      _page--; // Revertir la página si falla
      emit(SearchError(message: 'Error al cargar más resultados: ${e.toString()}'));
      // Volver al estado Loaded para no bloquear la UI
      emit(currentState); 
    }
  }
}
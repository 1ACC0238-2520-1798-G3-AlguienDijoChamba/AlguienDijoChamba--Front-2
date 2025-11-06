import 'package:alguiendijochamba_app_flutter/features/search/domain/query/search_professionals_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import '../../domain/usecases/search_professionals_usecase.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchProfessionalsUseCase searchProfessionalsUseCase; 
  
  // Parámetros internos de búsqueda y paginación
  int _page = 1;
  static const int _limit = 10;
  List<String> _currentTagFilters = [];
  String _currentSearchTerm = ''; // 🌟 AGREGADO: Estado interno para el texto de búsqueda
  
  // GETTERS
  List<String> get currentTagFilters => _currentTagFilters; 
  String get currentSearchTerm => _currentSearchTerm; 
  
  SearchCubit({
    required this.searchProfessionalsUseCase,
  }) : super(SearchInitial()); 

  // -----------------------------------------------------
  // A. Búsqueda Principal (Inicial, por Tag o por Texto)
  // -----------------------------------------------------

  Future<void> runSearch({
    List<String>? newTagFilters,
    String? newSearchTerm, // 🌟 NUEVO PARÁMETRO
  }) async {
    
    bool filtersChanged = false;

    // 1. Manejo de Filtros por Tags
    if (newTagFilters != null) {
        if (_currentTagFilters.toString() != newTagFilters.toString()) {
            _currentTagFilters = newTagFilters;
            filtersChanged = true;
        } 
    }
    
    // 2. Manejo del Término de Búsqueda
    final effectiveSearchTerm = newSearchTerm ?? _currentSearchTerm;
    
    if (_currentSearchTerm != effectiveSearchTerm) {
      _currentSearchTerm = effectiveSearchTerm;
      filtersChanged = true;
    }

    // Reinicia la página solo si algo cambió
    if (filtersChanged) {
        _page = 1; 
    }
    
    if (state is SearchLoading) return;
    
    emit(SearchLoading());

    try {
      // 1. Construye la Query con todos los parámetros
      final query = SearchProfessionalsQuery(
        page: _page,
        limit: _limit,
        tagIds: _currentTagFilters, 
        // 🔑 Pasa el término de búsqueda
        searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm, 
      );

      // 2. Ejecuta el Use Case
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
    if (state is! SearchLoaded || !(state as SearchLoaded).hasMore) return;

    final currentState = state as SearchLoaded;
    _page++; 

    emit(SearchLoadingMore(
      professionals: currentState.professionals,
      hasMore: currentState.hasMore,
    ));

    try {
      // 1. Construye la Query, manteniendo el searchTerm
      final query = SearchProfessionalsQuery(
        page: _page,
        limit: _limit,
        tagIds: _currentTagFilters, 
        // 🔑 Mantiene el término de búsqueda
        searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm, 
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
      _page--; 
      emit(SearchError(message: 'Error al cargar más resultados: ${e.toString()}'));
      emit(currentState); 
    }
  }
}
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_state.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/FilterTopBar.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/ProfessionalSearchResults.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/SearchBarWidget.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/TagFilterModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  // Recibimos los Use Cases para poder inicializar los Cubits
  final SearchProfessionalsUseCase searchUseCase;
  final GetAllTagsUseCase getAllTagsUseCase; 
  

  const SearchPage({
    super.key, 
    required this.searchUseCase,
    required this.getAllTagsUseCase,
  });

  // Función para mostrar el modal de tags
  void _showTagFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para que el modal sea de pantalla completa
      builder: (_) => BlocProvider.value(
        // Reusa la instancia existente del TagFilterCubit
        value: context.read<TagFilterCubit>(), 
        child: const TagFilterModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. Cubit para la gestión de la lista de Tags y selección
        BlocProvider<TagFilterCubit>(
          create: (_) => TagFilterCubit(getAllTagsUseCase: getAllTagsUseCase)
            ..loadTagCatalog(), 
        ),
        // 2. Cubit para la gestión de los resultados de búsqueda
        BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(searchProfessionalsUseCase: searchUseCase)
            ..runSearch(), 
        ),
      ],
      
      // 3. Listener: Dispara la búsqueda cuando los filtros de tags cambian
      child: BlocListener<TagFilterCubit, TagFilterState>(
        // 🚀 MEJORA: Solo escucha si los tags seleccionados realmente han cambiado.
        listenWhen: (previous, current) {
          if (previous is TagFilterLoaded && current is TagFilterLoaded) {
            // Compara las listas de IDs de tags.
            return previous.selectedTagIds.toString() != current.selectedTagIds.toString();
          }
          // También se activa si pasa de un estado no Loaded a Loaded (ej: después de cargar por primera vez).
          return current is TagFilterLoaded;
        },
        
        listener: (context, state) {
          // El Listener ya solo se ejecuta si la lista de tags cambió o si cargó por primera vez.
          if (state is TagFilterLoaded) {
            // ⚠️ La búsqueda se dispara directamente sin doble chequeo.
            context.read<SearchCubit>().runSearch(newTagFilters: state.selectedTagIds);
          }
        },
        
        child: Scaffold(
          // 🛑 NO HAY APPBAR
          body: Column(
            children: [
              // ➡️ 1. BARRA DE FILTROS DE TAGS (FilterTopBar) - PRIMERO
              BlocBuilder<TagFilterCubit, TagFilterState>(
                builder: (context, state) {
                  final isFilterActive = 
                      state is TagFilterLoaded ? state.selectedTagIds.isNotEmpty : false;
                  
                  return FilterTopBar(
                    title: 'Busqueda', // Título de la barra de control superior
                    isFilterActive: isFilterActive,
                    onFilterPressed: () => _showTagFilterModal(context),
                  );
                },
              ),

              // ➡️ 2. BARRA DE BÚSQUEDA (SearchBarWidget) - DEBAJO DE LA BARRA DE FILTROS
              const SearchBarWidget(), 
              
              // ➡️ 3. Lista de Resultados
              const Expanded(
                child: ProfessionalSearchResults(), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
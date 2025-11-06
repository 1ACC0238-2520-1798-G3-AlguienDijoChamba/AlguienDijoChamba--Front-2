import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/get_all_tags_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/domain/usecases/search_professionals_usecase.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_state.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/FilterTopBar.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/ProfessionalSearchResults.dart';
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
        // 🚀 CORRECCIÓN 1: El listenWhen ahora es simple, solo verifica el tipo
        listenWhen: (previous, current) => current is TagFilterLoaded,
        
        listener: (context, state) {
          // ⚠️ Coordinación: Obtenemos la instancia del SearchCubit
          final searchCubit = context.read<SearchCubit>();
          
          // Reiniciamos la búsqueda con los nuevos IDs de tags
          if (state is TagFilterLoaded) {
            // 🚀 CORRECCIÓN 2: Usamos el .read() para verificar si la lista realmente cambió,
            // si la lista ha cambiado, disparamos runSearch
            if (searchCubit.currentTagFilters.toString() != state.selectedTagIds.toString()) {
                searchCubit.runSearch(newTagFilters: state.selectedTagIds);
            }
          }
        },
        
        child: Scaffold(
          body: Column(
            children: [
              // ➡️ TopBar con el Icono de Filtro
              BlocBuilder<TagFilterCubit, TagFilterState>(
                builder: (context, state) {
                  // 🚀 CORRECCIÓN 3: Acceso seguro a selectedTagIds en el BlocBuilder
                  final isFilterActive = 
                      state is TagFilterLoaded ? state.selectedTagIds.isNotEmpty : false;
                  
                  return FilterTopBar(
                    title: 'BÚSQUEDA',
                    isFilterActive: isFilterActive,
                    onFilterPressed: () => _showTagFilterModal(context),
                  );
                },
              ),
              
              // ➡️ Lista de Resultados (El resto de la pantalla)
              const Expanded(
                // ¡Este widget está listo para consumir los resultados!
                child: ProfessionalSearchResults(), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
      isScrollControlled: true, 
      builder: (_) => BlocProvider.value(
        value: context.read<TagFilterCubit>(), 
        child: const TagFilterModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TagFilterCubit>(
          create: (_) => TagFilterCubit(getAllTagsUseCase: getAllTagsUseCase)
            ..loadTagCatalog(), 
        ),
        BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(searchProfessionalsUseCase: searchUseCase)
            ..runSearch(), 
        ),
      ],
      
      child: BlocListener<TagFilterCubit, TagFilterState>(
        listenWhen: (previous, current) {
          if (previous is TagFilterLoaded && current is TagFilterLoaded) {
            return previous.selectedTagIds.toString() != current.selectedTagIds.toString();
          }
          return current is TagFilterLoaded;
        },
        
        listener: (context, state) {
          if (state is TagFilterLoaded) {
            context.read<SearchCubit>().runSearch(newTagFilters: state.selectedTagIds);
          }
        },
        
        child: Scaffold(
          body: Column(
            children: [
              // ➡️ 1. BARRA DE FILTROS DE TAGS (FilterTopBar)
              BlocBuilder<TagFilterCubit, TagFilterState>(
                builder: (context, state) {
                  final isFilterActive = 
                      state is TagFilterLoaded ? state.selectedTagIds.isNotEmpty : false;
                  
                  return FilterTopBar(
                    title: 'Busqueda',
                    isFilterActive: isFilterActive,
                    onFilterPressed: () => _showTagFilterModal(context),
                  );
                },
              ),

              // ➡️ 2. BARRA DE BÚSQUEDA (SearchBarWidget)
              const SearchBarWidget(), 
              
              // ➡️ 3. Lista de Resultados
              Expanded(
                // 🛑 ENVOLVEMOS LA LISTA EN UN PADDING
                child: Padding(
                  // Aplica 16.0 de padding (margen) a la izquierda y derecha
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                  child: ProfessionalSearchResults(), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
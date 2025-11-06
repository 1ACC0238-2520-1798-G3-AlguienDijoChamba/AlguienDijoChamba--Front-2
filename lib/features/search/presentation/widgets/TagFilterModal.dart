import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/tag_filter_state.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/FilterTopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TagFilterModal extends StatelessWidget {
  const TagFilterModal({super.key});

  // Función auxiliar para obtener los IDs seleccionados de forma segura
  List<String> _getSelectedIds(TagFilterState state) {
    return state is TagFilterLoaded ? state.selectedTagIds : const [];
  }
  
  @override
  Widget build(BuildContext context) {
    final tagCubit = context.read<TagFilterCubit>();
    
    // Usamos BlocBuilder SOLO para la AppBar para acceder al estado actual y seguro
    return BlocBuilder<TagFilterCubit, TagFilterState>(
      // ⚠️ Usamos un BlocBuilder aquí para que el TopBar se redibuje al seleccionar tags
      builder: (context, state) {
        final selectedIds = _getSelectedIds(state);
        
        return Scaffold(
          // 🚀 CORRECCIÓN 1: Accedemos a los IDs seleccionados de forma segura
          appBar: FilterTopBar(
            title: 'Filtrar por Especialidad',
            onFilterPressed: () => Navigator.of(context).pop(), 
            isFilterActive: selectedIds.isNotEmpty, // ✅ Usamos la lista segura
          ) as PreferredSizeWidget,
          
          // -------------------------------------------------------------
          // Cuerpo del Modal
          // -------------------------------------------------------------
          body: Builder(
            builder: (context) {
              if (state is TagFilterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TagFilterError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is TagFilterLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8.0, 
                            runSpacing: 8.0,
                            // 🚀 CORRECCIÓN 2: Usamos 'availableTags' en lugar de 'allTags'
                            children: state.availableTags.map((tag) { 
                              final isSelected = state.selectedTagIds.contains(tag.id);
                              return InputChip(
                                label: Text(tag.name),
                                selected: isSelected,
                                onPressed: () {
                                  tagCubit.toggleTagSelection(tag.id); 
                                },
                                // ... (Estilos del chip) ...
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    
                    // ----------------------------------------
                    // Botón de Aplicar Filtros
                    // ----------------------------------------
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                        // ... (Estilos del botón) ...
                        child: const Text('Aplicar Filtros'),
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('Estado desconocido.'));
            },
          ),
        );
      },
    );
  }
}
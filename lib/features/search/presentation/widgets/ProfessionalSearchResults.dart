import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_load_more/easy_load_more.dart'; 

import '../cubit/search_cubit.dart'; 
import '../cubit/search_state.dart'; 
import 'professional_card.dart'; 

class ProfessionalSearchResults extends StatelessWidget {
  const ProfessionalSearchResults({super.key});

  // 2. TIPO DE ARGUMENTO CORREGIDO
  void _navigateToProfile(BuildContext context, SearchedProfessionalEntity prof) {
    // Usamos el ID para la navegación a la vista de perfil completo
    Navigator.of(context).pushNamed(
      '/process/${prof.professionalId}',
      arguments: prof,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => searchCubit.runSearch(newTagFilters: searchCubit.currentTagFilters),
                  child: const Text('Reintentar Búsqueda'),
                ),
              ],
            ),
          );
        }

        // Extracción segura de la lista
        final List<SearchedProfessionalEntity> professionals;
        final bool hasMore;
        final bool isLoadingMore = state is SearchLoadingMore;

        if (state is SearchLoaded) {
            professionals = state.professionals;
            hasMore = state.hasMore;
        } else if (state is SearchLoadingMore) {
            professionals = state.professionals;
            hasMore = state.hasMore;
        } else {
            professionals = [];
            hasMore = false;
        }
        
        if (professionals.isEmpty && !hasMore) {
          return const Center(
            child: Text("No se encontraron profesionales con los filtros seleccionados."),
          );
        }

        // Renderizar la lista con Paginación
        return EasyLoadMore(
          onLoadMore: () async {
            await searchCubit.loadMore();
            return true; 
          }, 
          isFinished: !hasMore,
              
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: professionals.length + (isLoadingMore ? 1 : 0), 
            itemBuilder: (context, index) {
              
              if (index == professionals.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final prof = professionals[index];

              return InkWell(
                onTap: () => _navigateToProfile(context, prof), 
                child: ProfessionalCard( 
                  // 3. ASIGNACIÓN DE CAMPOS CORREGIDA
                  nombres: prof.userName ?? 'Profesional', 
                  apellidos: '', 
                  professionalLevel: prof.professionalLevel,
                  starRating: prof.starRating,
                  availableBalance: prof.hourlyRate, // Usamos el campo de reputación
                  fotoPerfilUrl: prof.profilePhotoUrl ?? '',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
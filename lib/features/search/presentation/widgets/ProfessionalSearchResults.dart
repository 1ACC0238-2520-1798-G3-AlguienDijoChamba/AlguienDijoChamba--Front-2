import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_load_more/easy_load_more.dart'; 
// 💡 Necesitas esta importación para usar PersistentNavBarNavigator
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; 


import '../cubit/search_cubit.dart'; 
import '../cubit/search_state.dart'; 
import 'professional_card.dart'; 


// --- IMPORTACIONES PARA PROCESS FEATURE ---
import 'package:alguiendijochamba_app_flutter/features/process/presentation/pages/professional_detail_page.dart';
//IMPORTS DE PROCESS
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';
// ------------------------------------------------------------------


class ProfessionalSearchResults extends StatelessWidget {
  const ProfessionalSearchResults({super.key});


  // 🚀 FUNCIÓN DE NAVEGACIÓN UNIFICADA
  void _navigateToProfile(BuildContext context, SearchedProfessionalEntity prof) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: BlocProvider<ProcessBloc>(
        create: (_) => injector<ProcessBloc>(),
        child: ProfessionalDetailPage(professionalId: prof.professionalId),
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  // ✅ FUNCIÓN AUXILIAR PARA FILTRAR IDS INVÁLIDOS
  List<SearchedProfessionalEntity> _filterValidProfessionals(List<SearchedProfessionalEntity> professionals) {
    return professionals.where((p) => 
      p.professionalId != null && 
      p.professionalId.isNotEmpty && 
      p.professionalId != '00000000-0000-0000-0000-000000000000'
    ).toList();
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


        final List<SearchedProfessionalEntity> professionals;
        final bool hasMore;
        final bool isLoadingMore = state is SearchLoadingMore;


        if (state is SearchLoaded) {
            // ✅ FILTRAR PROFESIONALES CON IDS VÁLIDOS
            professionals = _filterValidProfessionals(state.professionals);
            hasMore = state.hasMore;
        } else if (state is SearchLoadingMore) {
            // ✅ FILTRAR PROFESIONALES CON IDS VÁLIDOS
            professionals = _filterValidProfessionals(state.professionals);
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


              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ProfessionalCard( 
                  // ✅ LLAMADA A LA NAVEGACIÓN USANDO EL MÉTODO UNIFICADO
                  onTap: () => _navigateToProfile(context, prof), 
                  
                  // ASIGNACIÓN DE CAMPOS
                  nombres: prof.userName ?? 'Profesional', 
                  apellidos: '', 
                  professionalLevel: prof.professionalLevel,
                  starRating: prof.starRating,
                  availableBalance: prof.hourlyRate, 
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

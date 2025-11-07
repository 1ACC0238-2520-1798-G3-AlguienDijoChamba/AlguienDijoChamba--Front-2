// Archivo: lib/features/search/presentation/widgets/professional_search_results.dart

import 'package:alguiendijochamba_app_flutter/features/search/domain/entities/search_profesional_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_load_more/easy_load_more.dart'; 
// 💡 Necesitas esta importación para usar PersistentNavBarNavigator
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; 

import '../cubit/search_cubit.dart'; 
import '../cubit/search_state.dart'; 
import 'professional_card.dart'; 

// --- WIDGET TEMPORAL (DEBE SER EL MISMO QUE USAS EN APP_ROUTER) ---
// Asumimos que esta clase está disponible y espera un String.
class ProfessionalDetailsPage extends StatelessWidget {
  final String professionalId;
  const ProfessionalDetailsPage({super.key, required this.professionalId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Profesional')),
      body: Center(
        child: Text('Cargando datos para el Profesional ID: $professionalId', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
// ------------------------------------------------------------------

class ProfessionalSearchResults extends StatelessWidget {
  const ProfessionalSearchResults({super.key});

  // 🚀 FUNCIÓN DE NAVEGACIÓN UNIFICADA
  void _navigateToProfile(BuildContext context, SearchedProfessionalEntity prof) {
    // Usamos el método de navegación del paquete PersistentNavBar para asegurar el push.
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: ProfessionalDetailsPage(
        professionalId: prof.professionalId, // Pasa el ID (asumido como String)
      ),
      withNavBar: false, // Oculta la barra inferior en la nueva pantalla
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
// Archivo: lib/features/home/presentation/widgets/suggested_professionals_list.dart

import 'package:alguiendijochamba_app_flutter/core/navigation/app_router.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/professional_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_state.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class SuggestedProfessionalsList extends StatelessWidget {
  const SuggestedProfessionalsList({super.key});

  // Función auxiliar para dividir el nombre y apellido
  List<String> _splitName(String? userName) {
    final name = userName ?? 'N/A N/A';
    final parts = name.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return [firstName, lastName];
  }

  @override
  Widget build(BuildContext context) {
    // Se usa BlocProvider para inicializar y proveer el SearchCubit
    return BlocProvider(
      create: (context) {
        final cubit = injector<SearchCubit>();
        // Llama a la búsqueda inicial para obtener sugerencias
        cubit.runSearch(newTagFilters: [], newSearchTerm: ''); 
        return cubit;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Suggested for You',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Bloque que escucha el estado del Cubit
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading || state is SearchInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              
              if (state is SearchLoaded) {
                if (state.professionals.isEmpty) {
                  return const Center(child: Text('No se encontraron profesionales sugeridos.'));
                }
                
                final allProfessionals = state.professionals;
                // Limita el conteo a un máximo de 2 para la vista de sugerencias
                final itemCount = allProfessionals.length > 2 ? 2 : allProfessionals.length;
                
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount, 
                      itemBuilder: (context, index) {
                        final p = allProfessionals[index];
                        final names = _splitName(p.userName);
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ProfessionalCard(
                            nombres: names[0],
                            apellidos: names[1],
                            professionalLevel: p.professionalLevel ?? 'Nivel Desconocido',
                            starRating: p.starRating,
                            availableBalance: p.hourlyRate,
                            fotoPerfilUrl: p.profilePhotoUrl,
                            
                            // 🚀 LÓGICA DE REDIRECCIÓN AÑADIDA AQUÍ
                            onTap: () {
                              // Esto te lleva a la pantalla de detalles del profesional
                              PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: ProfessionalDetailsPage(
                                      professionalId: p.professionalId, // Asume que esto es correcto
                                  ),
                                  withNavBar: false, // Ocultar la barra de navegación en la nueva pantalla
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                            },
                          ),
                        );
                      },
                    ),
                    
                    // Botón "Ver Todos"
                    if (allProfessionals.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: 24.0),
                        child: TextButton(
                          onPressed: () {
                            // Navegar a la página de búsqueda/lista completa
                            Navigator.of(context).pushNamed('/search_page'); 
                          },
                          child: const Text(
                            'View All Suggested (More than 2)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                );
              }
              // En cualquier otro caso (ej. si el estado es inesperado)
              return const SizedBox.shrink(); 
            },
          ),
        ],
      ),
    );
  }
}
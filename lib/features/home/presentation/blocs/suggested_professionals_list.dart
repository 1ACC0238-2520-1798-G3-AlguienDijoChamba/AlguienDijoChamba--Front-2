// Archivo: lib/features/home/presentation/widgets/suggested_professionals_list.dart

import 'package:alguiendijochamba_app_flutter/features/search/presentation/widgets/professional_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_cubit.dart';
import 'package:alguiendijochamba_app_flutter/features/search/presentation/cubit/search_state.dart';

class SuggestedProfessionalsList extends StatelessWidget {
  const SuggestedProfessionalsList({super.key});

  List<String> _splitName(String? userName) {
      final name = userName ?? 'N/A N/A';
      final parts = name.split(' ');
      final firstName = parts.first;
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      return [firstName, lastName];
  }

  @override
  Widget build(BuildContext context) {
    // Usamos BlocProvider.value si el Cubit ya está disponible en el árbol (ej. HomePage)
    // Si no, lo creamos aquí (como en el ejemplo anterior)
    return BlocProvider(
      create: (context) {
        final cubit = injector<SearchCubit>();
        // Aquí podrías usar una query específica para sugerencias (ej. sin filtros)
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
                // 🛑 LÍMITE CLAVE: Aseguramos que el contador no exceda 2
                final itemCount = allProfessionals.length > 2 ? 2 : allProfessionals.length;
                
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // 🛑 Aquí es donde limitamos a un máximo de 2
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
                          ),
                        );
                      },
                    ),
                    
                    // Botón para ver más, si hay más de 2 sugerencias
                    if (allProfessionals.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: 24.0),
                        child: TextButton(
                          onPressed: () {
                            // 🚀 Navegar a la SearchPage (o lista completa)
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
              return const SizedBox.shrink(); 
            },
          ),
        ],
      ),
    );
  }
}
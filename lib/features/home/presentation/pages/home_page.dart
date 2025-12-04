// Archivo: lib/home_page.dart (CORREGIDO Y LIMPIO)

import 'package:alguiendijochamba_app_flutter/features/home/presentation/blocs/suggested_professionals_list.dart';
import 'package:alguiendijochamba_app_flutter/features/home/presentation/widgets/gold_member_banner.dart';
import 'package:alguiendijochamba_app_flutter/features/home/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


// -----------------------------------------------------------------------------
// HOME WIDGET (PÁGINA PRINCIPAL)
// -----------------------------------------------------------------------------
class Home extends StatelessWidget {
  final PersistentTabController controller;
  const Home({super.key, required this.controller}); // Constructor OK

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado (Pasa el controlador)
          HomeHeader(controller: controller),
          
          // 2. Servicios Populares con botón '+'
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 24.0),
            child: _buildPopularServices(context),
          ),


          // 3. Contenido Sugerido/Profesionales
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SuggestedProfessionalsList(), 
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Contiene la lógica para la lista de servicios y el botón '+'
  Widget _buildPopularServices(BuildContext context) {
    final services = [
      {'name': 'Plumbing', 'emoji': '🔧'},
      {'name': 'Electrical', 'emoji': '⚡'},
      {'name': 'Cleaning', 'emoji': '🧹'},
      {'name': 'Painting', 'emoji': '🎨'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Services',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18, 
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90, 
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length + 1, 
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == services.length) {
                return _buildMoreButtonCard(context); 
              }

              final service = services[index];
              return _buildServiceCard(service['name']!, service['emoji']!);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildServiceCard(String name, String emoji) {
    return InkWell(
      onTap: () => debugPrint('Servicio: $name'),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Tarjeta con el símbolo '+' para ver más
  Widget _buildMoreButtonCard(BuildContext context) {
    return InkWell(
      onTap: () {
        // 🛑 CORRECCIÓN: Usamos 'this.controller' directamente
        // Eliminamos el intento fallido de usar PersistentNavBar.of(context)
        controller.jumpToTab(1); // Esto es seguro porque Home ahora requiere el controller
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB), // Color gris claro
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 28, color: Color(0xFF4B5563)),
            SizedBox(height: 4),
            Text('Más', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4B5563))),
          ],
        ),
      ),
    );
  }
}
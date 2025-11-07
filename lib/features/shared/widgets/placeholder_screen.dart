// Archivo sugerido: lib/core/widgets/placeholder_screen.dart

import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:flutter/material.dart';
// Ajusta la ruta de importación de TopBar si es diferente

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos Builder para obtener un contexto seguro para el pop
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              // 🛑 Usamos tu TopBar aquí
              TopBar(title: title), 
              
              // Contenido Placeholder
              Expanded(
                child: Center(
                  child: Text(
                    '$title - EN CONSTRUCCIÓN',
                    style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
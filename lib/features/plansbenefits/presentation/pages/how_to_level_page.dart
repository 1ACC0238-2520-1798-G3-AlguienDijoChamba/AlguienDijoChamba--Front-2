import 'package:flutter/material.dart';
import '../widgets/level_step_card.dart';

class HowToLevelPage extends StatelessWidget {
  const HowToLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Cómo subir de nivel?'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            LevelStepCard(
              icon: Icons.build,
              title: 'Contrata Servicios',
              description: 'Cada servicio de reparación te acerca al siguiente nivel',
            ),
            SizedBox(height: 16),
            LevelStepCard(
              icon: Icons.star,
              title: 'Califica Técnicos',
              description: 'Tu feedback te da puntos extra',
            ),
            SizedBox(height: 16),
            LevelStepCard(
              icon: Icons.group,
              title: 'Recomienda Amigos',
              description: 'Comparte y gana recompensas',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Comenzar Ahora', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/plan_card.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sistema de Niveles de Usuario'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Sube de nivel según tu actividad y disfruta de beneficios exclusivos en nuestros servicios de reparación y mantenimiento',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                PlanCard(
                  title: 'Nivel Bronce',
                  color: Color(0xFFB87333),
                  icon: 'B',
                  benefits: [
                    'Acceso básico a técnicos',
                    'Soporte estándar',
                    'Acceso a categorías principales'
                  ],
                ),
                PlanCard(
                  title: 'Nivel Plata',
                  color: Colors.grey,
                  icon: 'P',
                  benefits: [
                    'Técnicos verificados premium',
                    'Soporte prioritario',
                    'Descuentos exclusivos',
                    'Acceso a todas las categorías'
                  ],
                ),
                PlanCard(
                  title: 'Nivel Oro',
                  color: Color(0xFFFFC107),
                  icon: 'O',
                  benefits: [
                    'Técnicos elite certificados',
                    'Soporte 24/7 personalizado',
                    'Descuentos mayores en servicios',
                    'Servicios gratuitos ocasionales',
                    'Acceso prioritario a nuevos técnicos'
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/howToLevel');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('¿Cómo subir de nivel?', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

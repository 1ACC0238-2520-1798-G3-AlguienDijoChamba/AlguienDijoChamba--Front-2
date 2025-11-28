import 'package:flutter/material.dart';

class LevelInfoPage extends StatelessWidget {
  const LevelInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sistema de Niveles de Usuario",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sube de nivel según tu actividad y disfruta de beneficios exclusivos en nuestros servicios.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // --------------------------
            // TARJETA NIVEL BRONCE
            // --------------------------
            const _LevelCard(
              title: "Nivel Bronce",
              color: Color(0xFF8B4513),
              borderColor: Color(0xFF8B4513),
              benefits: [
                "Acceso básico a técnicos",
                "Soporte estándar",
                "Acceso a categorías principales",
              ],
            ),

            const SizedBox(height: 16),

            // --------------------------
            // TARJETA NIVEL PLATA
            // --------------------------
            const _LevelCard(
              title: "Nivel Plata",
              color: Colors.grey,
              borderColor: Colors.grey,
              benefits: [
                "Técnicos verificados premium",
                "Soporte prioritario",
                "Descuentos exclusivos",
                "Acceso a todas las categorías",
              ],
            ),

            const SizedBox(height: 16),

            // --------------------------
            // TARJETA NIVEL ORO
            // --------------------------
            const _LevelCard(
              title: "Nivel Oro",
              color: Colors.orange,
              borderColor: Colors.orange,
              benefits: [
                "Técnicos elite",
                "Soporte 24/7",
                "Mayores descuentos",
                "Servicios gratuitos ocasionales",
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "¿Cómo subir de nivel?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color borderColor;
  final List<String> benefits;

  const _LevelCard({
    required this.title,
    required this.color,
    required this.borderColor,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // SE ESTIRA COMPLETO
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 18, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

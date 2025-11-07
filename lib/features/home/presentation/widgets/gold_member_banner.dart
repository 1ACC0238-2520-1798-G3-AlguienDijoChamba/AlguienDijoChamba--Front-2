// Archivo sugerido: lib/features/home/presentation/widgets/_gold_member_banner.dart
//aca va mi coso de plans
import 'package:flutter/material.dart';

class GoldMemberBanner extends StatelessWidget {
  const GoldMemberBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // 🛑 Envolvemos el Container en InkWell para hacerlo clickeable
    return InkWell(
      onTap: () {
        // 🛑 Navegamos a la ruta de planes y beneficios
        // Usamos rootNavigator: true para salir del contexto de la barra de pestañas
        Navigator.of(context, rootNavigator: true).pushNamed('/plans_and_benefits');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 80, 
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFD9900), Color(0xFFFF6800)], 
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Columna de Texto
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏆 Gold Member Perks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                Text(
                  'Book 3 services, get 1 free!',
                  style: TextStyle(
                    color: Color(0xFFFEF3C6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),

            // Botón '25% OFF'
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '25% OFF',
                style: TextStyle(
                  color: Color(0xFFE17100),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
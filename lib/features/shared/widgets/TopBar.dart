import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const TopBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // 💡 Validación clave: Comprueba si hay una ruta anterior a la cual volver.
    final bool canPop = Navigator.canPop(context);

    // Define la acción de retorno segura:
    final VoidCallback safeBackAction = onBack ?? 
        () {
          // Solo llama a pop si canPop es true.
          if (canPop) {
            Navigator.pop(context);
          }
        };

    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1.35,
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🛑 1. El botón de volver solo se renderiza si canPop es true.
          if (canPop)
            GestureDetector(
              onTap: safeBackAction,
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Color(0xFF1F2937),
              ),
            ),
          
          // 🛑 2. Ajusta el espacio para que el título se alinee correctamente si el botón está ausente.
          SizedBox(width: canPop ? 16 : 0), 
          
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ],
      ),
    );
  }
}
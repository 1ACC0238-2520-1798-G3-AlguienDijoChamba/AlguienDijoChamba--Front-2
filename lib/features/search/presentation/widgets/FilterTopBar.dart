import 'package:flutter/material.dart';

class FilterTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onFilterPressed; // Acción a ejecutar al presionar el icono de filtro
  final bool isFilterActive; // Indica si hay filtros seleccionados actualmente
  
  const FilterTopBar({
    super.key,
    required this.title,
    required this.onFilterPressed,
    this.isFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // 💡 Validación clave: Comprueba si hay una ruta anterior a la cual volver.
    final bool canPop = Navigator.canPop(context);

    return Container(
      width: double.infinity,
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
      child: SafeArea( // Usamos SafeArea para evitar el notch
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botón de volver (si aplica)
            if (canPop)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            
            // Título
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // 🚀 Botón de Filtro
            GestureDetector(
              onTap: onFilterPressed,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12),
                child: Icon(
                  Icons.filter_list_rounded,
                  size: 26,
                  // Color para indicar si el filtro está activo (mejor UX)
                  color: isFilterActive ? Colors.blue.shade700 : const Color(0xFF1F2937),
                ),
              ),
            ),
            // Indicador visual de filtro activo (opcional)
            if (isFilterActive)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Define el tamaño preferido para usarlo como AppBar o en Column
  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
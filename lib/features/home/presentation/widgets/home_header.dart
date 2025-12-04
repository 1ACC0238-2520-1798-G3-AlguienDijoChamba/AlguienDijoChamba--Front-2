import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeHeader extends StatelessWidget {
  final PersistentTabController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2563EB), Color(0xFF155CFB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoAndActions(context), // Contiene los 3 iconos
          const SizedBox(height: 16),
          _buildSearchBarField(context), // Campo de búsqueda que navega
        ],
      ),
    );
  }

  // Iconos de Notificación, Chat y Perfil
  Widget _buildUserInfoAndActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'What do you need fixed today?',
              style: TextStyle(
                color: Color(0xFFDAEAFE),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        
        // Iconos de Acción: Notificación, Chat, Perfil
      Row(
        children: [
          // 🛑 NOTIFICACIONES
          _buildCircularIconButton(
            Icons.notifications_none, 
            () => Navigator.of(context, rootNavigator: true).pushNamed('/notifications')
          ),
          const SizedBox(width: 8),
          
          // 🛑 CHAT
          _buildCircularIconButton(
            Icons.chat_bubble_outline, 
            () => Navigator.of(context, rootNavigator: true).pushNamed('/chat')
          ),
          const SizedBox(width: 8),
          
        ],
      ),
      ],
    );
  }

  // Widget Auxiliar para los botones circulares
  Widget _buildCircularIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  // Campo de Búsqueda que navega a SearchPage
  Widget _buildSearchBarField(BuildContext context) {
    
    // 🛑 LÓGICA DE NAVEGACIÓN CORREGIDA: Usa el this.controller
    void _jumpToSearch() {
      // El índice 1 corresponde a la pestaña "Search"
      controller.jumpToTab(1); 
    }
    
    return GestureDetector(
      onTap: _jumpToSearch,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        // AbsorbPointer previene que el TextField interno capture el toque
        child: AbsorbPointer( 
          child: TextField(
            enabled: false, // Deshabilita la edición para que solo navegue
            decoration: InputDecoration(
              hintText: 'What do you need fixed today?',
              hintStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
              // Botón '>' que también navega
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF2563EB), size: 18),
                onPressed: _jumpToSearch, // Llama a la función para cambiar de pestaña
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
            ),
          ),
        ),
      ),
    );
  }
}
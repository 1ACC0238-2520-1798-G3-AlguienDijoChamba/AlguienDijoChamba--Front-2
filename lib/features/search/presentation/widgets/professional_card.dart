import 'package:flutter/material.dart';

class ProfessionalCard extends StatelessWidget {
  final String nombres;
  final String apellidos;
  final String professionalLevel; // Nivel de membresía (Ej: 'Silver', 'Bronze')
  final double starRating;
  final double availableBalance; // Precio por hora
  final String? fotoPerfilUrl;

  const ProfessionalCard({
    super.key,
    required this.nombres,
    required this.apellidos,
    required this.professionalLevel,
    required this.starRating,
    required this.availableBalance,
    this.fotoPerfilUrl,
  });

  // Etiqueta del nivel profesional (sin cambios)
  Widget _buildLevelTag(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(
          width: 1.35,
          color: const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: Color(0xFF1D2838),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Arimo',
        ),
      ),
    );
  }

  // Ícono de verificación (Badge azul) (sin cambios)
  Widget _buildVerificationBadge() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: 20, 
        height: 20,
        decoration: const BoxDecoration(
          color: Color(0xFF2B7FFF),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.check, color: Colors.white, size: 12), 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      // 🛑 MANTENEMOS LA ALTURA DE 68.0
      height: 68.0, 
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4), 
      // MANTENEMOS EL PADDING DE 9.0
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 9.0), 
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.35,
          color: const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Avatar con Badge (48px)
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: (fotoPerfilUrl != null && fotoPerfilUrl!.isNotEmpty)
                    ? NetworkImage(fotoPerfilUrl!)
                    : const AssetImage('assets/images/default_profile.png') as ImageProvider,
              ),
              _buildVerificationBadge(),
            ],
          ),
          
          const SizedBox(width: 13),

          // 2. Información Central (Nombre, Precio por Hora + Nivel)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre completo
                Text(
                  "$nombres $apellidos",
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Arimo',
                    overflow: TextOverflow.ellipsis,
                    height: 1.2, // 🛑 REDUCIMOS LA ALTURA DE LÍNEA PREDETERMINADA
                  ),
                ),
                
                // 🛑 REDUCIMOS EL ESPACIO A 2.0 (Era 4.0)
                const SizedBox(height: 2.0),

                // Precio por Hora Y la Etiqueta de Nivel
                Row(
                  children: [
                    // Precio por Hora
                    Text(
                      "\$${availableBalance.toStringAsFixed(0)}/hr",
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arimo',
                        height: 1.2, // 🛑 REDUCIMOS LA ALTURA DE LÍNEA
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Etiqueta de Nivel
                    _buildLevelTag(professionalLevel),
                  ],
                ),
              ],
            ),
          ),

          // 3. Rating
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    starRating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Arimo',
                      height: 1.2, // 🛑 REDUCIMOS LA ALTURA DE LÍNEA
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
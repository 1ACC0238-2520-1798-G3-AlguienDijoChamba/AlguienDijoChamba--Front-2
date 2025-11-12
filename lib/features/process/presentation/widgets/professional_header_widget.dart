import 'package:flutter/material.dart';
import '../../domain/entities/professional.dart';

class ProfessionalHeaderWidget extends StatelessWidget {
  final Professional professional;
  final bool showEmail;

  const ProfessionalHeaderWidget({
    Key? key,
    required this.professional,
    this.showEmail = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image with verification badge
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF6366F1),
                    backgroundImage: _getProfileImage(professional.profileImage),
                    child: _getProfileImage(professional.profileImage) == null
                        ? Text(
                            _getInitials(professional.fullName),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Name and specialties
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          professional.fullName.split(' ').take(2).join(' '),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB74D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            professional.badgeLevel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: professional.specialties.map((specialty) {
                        return Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Rating, distance, email
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
              const SizedBox(width: 4),
              Text(
                '${professional.rating} (${professional.reviewCount})',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on, color: Color(0xFF757575), size: 16),
              const SizedBox(width: 4),
              Text(
                '${professional.distance} mi',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              if (showEmail) ...[
                const SizedBox(width: 16),
                const Icon(Icons.email, color: Color(0xFF757575), size: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Método helper para validar y obtener la imagen de perfil
  ImageProvider? _getProfileImage(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    
    // Validar que la URL sea válida (http o https)
    if (url.startsWith('http://') || url.startsWith('https://')) {
      try {
        return NetworkImage(url);
      } catch (e) {
        print('Error loading profile image: $e');
        return null;
      }
    }
    
    // Si no es una URL válida, retornar null
    return null;
  }

  // Método helper para obtener las iniciales del nombre
  String _getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.isEmpty) return '?';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0].toUpperCase()}${names[1][0].toUpperCase()}';
  }
}

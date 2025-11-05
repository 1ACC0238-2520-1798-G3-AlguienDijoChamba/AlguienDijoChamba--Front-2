import 'package:flutter/material.dart';

class ProfessionalCard extends StatelessWidget {
  final String nombres;
  final String apellidos;
  final String professionalLevel;
  final double starRating;
  final double availableBalance;
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundImage: (fotoPerfilUrl != null && fotoPerfilUrl!.isNotEmpty)
                  ? NetworkImage(fotoPerfilUrl!)
                  : const AssetImage('assets/images/default_profile.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre completo
                  Text(
                    "$nombres $apellidos",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  // Nivel profesional
                  Text(
                    professionalLevel,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(starRating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            // Precio / balance
            Text(
              "S/. ${availableBalance.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

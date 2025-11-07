import 'package:flutter/material.dart';

class LevelStepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const LevelStepCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent.shade100),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

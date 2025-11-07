import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final Color color;
  final String icon;
  final List<String> benefits;

  const PlanCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 18, backgroundColor: color, child: Text(icon, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Beneficios exclusivos', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
          const SizedBox(height: 8),
          for (var b in benefits)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check, color: Colors.green, size: 14),
                const SizedBox(width: 4),
                Expanded(child: Text(b, style: const TextStyle(fontSize: 12))),
              ],
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: color),
            child: const Text('Alcanzar Nivel'),
          ),
        ],
      ),
    );
  }
}

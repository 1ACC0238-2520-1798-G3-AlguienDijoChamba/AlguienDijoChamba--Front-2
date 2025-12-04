import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final int points;

  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.card_giftcard, color: Colors.amber, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Claim'),
        ),
      ),
    );
  }
}

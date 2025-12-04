import 'package:flutter/material.dart';

class RewardActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final int points;

  const RewardActivityItem({
    super.key,
    required this.title,
    required this.date,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = points > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(date, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(
            '${isPositive ? '+' : ''}$points',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

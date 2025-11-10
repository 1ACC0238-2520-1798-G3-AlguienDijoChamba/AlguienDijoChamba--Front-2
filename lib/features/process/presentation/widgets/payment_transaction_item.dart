import 'package:flutter/material.dart';

class PaymentTransactionItem extends StatelessWidget {
  final bool isCompleted; // true = flecha roja abajo, false = flecha azul arriba
  final String title;
  final String date;
  final String transactionId;
  final String amount;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool showButton;

  const PaymentTransactionItem({
    Key? key,
    required this.isCompleted,
    required this.title,
    required this.date,
    required this.transactionId,
    required this.amount,
    required this.buttonText,
    this.onButtonPressed,
    this.showButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Arrow icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFFFEBEE)
                  : const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.south_west : Icons.north_east,
              color: isCompleted
                  ? const Color(0xFFE53935)
                  : const Color(0xFF2196F3),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date  •  $transactionId',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          
          // Amount and button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              if (showButton) ...[
                const SizedBox(height: 4),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted
                        ? const Color(0xFF9E9E9E)
                        : const Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

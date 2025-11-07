// lib/features/process/presentation/pages/payment_success_page.dart

import 'package:flutter/material.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import 'active_job_page.dart';


class PaymentSuccessPage extends StatelessWidget {
  final Professional professional;
  final Job job;
  final double amount;

  const PaymentSuccessPage({
    super.key,
    required this.professional,
    required this.job,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // ✅ Checkmark animado
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Título
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Monto
                Text(
                  'S/${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4169E1),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Descripción
                const Text(
                  'Your payment has been processed successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Detalle de la transacción
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Professional', professional.fullName),
                      const Divider(height: 16),
                      _buildDetailRow('Amount', 'S/${amount.toStringAsFixed(2)}'),
                      const Divider(height: 16),
                      _buildDetailRow('Status', '✅ Completed'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // ✨ CAMBIO: Botón Continue redirige a ActiveJobPage
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActiveJobPage(
                          professional: professional,
                          job: job,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4169E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

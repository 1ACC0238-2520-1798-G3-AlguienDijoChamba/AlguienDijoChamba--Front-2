// lib/features/process/presentation/pages/payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../widgets/professional_header_widget.dart';
import '../widgets/payment_transaction_item.dart';
import 'payment_success_page.dart';


class PaymentPage extends StatefulWidget {
  final Professional professional;
  final Job job;

  const PaymentPage({
    super.key,
    required this.professional,
    required this.job,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final double advancePayment = widget.job.totalCost / 2;
    final double totalAmount = widget.job.totalCost;
    final double availableBalance = 1250.0; // Mock data

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Process',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional Header
            ProfessionalHeaderWidget(professional: widget.professional),
            
            const SizedBox(height: 20),
            
            // Available Balance Card (azul con gradiente)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B8DEE), Color(0xFF4169E1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'S/${availableBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ✨ ARREGLADO: withOpacity → withValues
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payments Section
            const Text(
              'Payments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 16),
            
            // Primera transacción (50% adelantado - completado)
            PaymentTransactionItem(
              isCompleted: true,
              title: 'Bank transfer withdrawal',
              date: '3 jan 2025',
              transactionId: 'WD-2024-003',
              amount: 'S/${advancePayment.toStringAsFixed(0)}',
              buttonText: 'Pay',
              showButton: false,
            ),
            
            // Segunda transacción (50% pendiente - futuro)
            PaymentTransactionItem(
              isCompleted: false,
              title: 'Bank transfer withdrawal',
              date: '4 jan 2025',
              transactionId: 'WD-2024-003',
              amount: 'S/${advancePayment.toStringAsFixed(0)}',
              buttonText: 'Pay Later',
              showButton: false,
            ),
            
            const SizedBox(height: 16),
            
            // Pending and Total Earned Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF757575),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'S/${advancePayment.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Earned',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'S/${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _processPaymentLocally(context, advancePayment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4169E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pay',
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
    );
  }

  // ✨ ARREGLADO: BuildContext async gaps con mounted check
  Future<void> _processPaymentLocally(
    BuildContext context,
    double amount,
  ) async {
    try {
      // 1. Mostrar loading dialog
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // 2. Simular procesamiento (2 segundos)
      await Future.delayed(const Duration(seconds: 2));

      // 3. Cerrar loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // 4. Mostrar snackbar de éxito
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Payment processed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 5. Esperar y navegar a success page
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            professional: widget.professional,
            job: widget.job,
            amount: amount,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

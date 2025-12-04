import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/process_repository.dart';
import '../blocs/process_bloc.dart';

class PaymentSuccessPage extends StatefulWidget {
  final Professional professional;
  final Job job;
  final double amount;
  final ProcessRepository repository;

  const PaymentSuccessPage({
    super.key,
    required this.professional,
    required this.job,
    required this.amount,
    required this.repository,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  bool _isSavingActiveJob = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  Future<void> _saveActiveJobAfterPayment() async {
    try {
      setState(() => _isSavingActiveJob = true);

      final jobData = {
        'jobId': widget.job.id,
        'professionalId': widget.professional.id,
        'customerId': widget.professional.id,
        'specialty': widget.job.specialty,
        'description': widget.job.description,
        'address': widget.job.address,
        'scheduledDate': widget.job.scheduledDate.toIso8601String(),
        'scheduledHour': widget.job.scheduledHour,
        'additionalMessage': widget.job.additionalMessage ?? '',
        'categories': widget.job.categories,
        'paymentMethod': 'Credit Card',
        'totalCost': widget.job.totalCost,
      };

      print('💾 GUARDANDO ACTIVE JOB: $jobData');
      await widget.repository.saveActiveJob(jobData);
      print('✅ ACTIVE JOB GUARDADO EXITOSAMENTE');
    } catch (e) {
      print('❌ ERROR AL GUARDAR ACTIVE JOB: $e');
    } finally {
      if (mounted) {
        setState(() => _isSavingActiveJob = false);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Payment Successful',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'S/${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4169E1),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Your payment has been processed successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Professional',
                          widget.professional.fullName,
                        ),
                        const Divider(height: 16),
                        _buildDetailRow(
                          'Amount',
                          'S/${widget.amount.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 16),
                        _buildDetailRow('Status', '✅ Completed'),
                        if (_isSavingActiveJob) ...[
                          const Divider(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Saving job...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSavingActiveJob
                          ? null
                          : () {
                              // 1) Obtener el bloc actual
                              final processBloc = context.read<ProcessBloc>();

                              // 2) Recargar la lista de jobs
                              processBloc.add(const LoadAvailableJobs());

                              // 3) Ir a /main y limpiar el stack
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/main',
                                (route) => false,
                              );
                            },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4169E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isSavingActiveJob ? 'Processing...' : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
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

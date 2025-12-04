import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import '../widgets/professional_header_widget.dart';
import '../widgets/report_reason_button.dart';
import '../widgets/payment_transaction_item.dart';

class CancelJobPage extends StatefulWidget {
  final Professional professional;
  final Job job;

  const CancelJobPage({Key? key, required this.professional, required this.job})
    : super(key: key);

  @override
  State<CancelJobPage> createState() => _CancelJobPageState();
}

class _CancelJobPageState extends State<CancelJobPage> {
  String? _selectedReason;

  final List<String> _cancellationReasons = [
    'No response from the technician',
    'I no longer need the service',
    'The technician was rude or disrespectful',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final double refundAmount = widget.job.totalCost / 2 * 0.9;
    final double pendingRefund = widget.job.totalCost / 2 * 0.1;

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
          'Cancel Job',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<ProcessBloc, ProcessState>(
        listener: (context, state) {
          print('🔍 CancelJobPage - Estado: $state');

          if (state is JobCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Job cancelled successfully'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;

              // Cierra TODAS las pantallas hasta la primera (home)
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          } else if (state is ProcessError) {
            print('❌ Error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfessionalHeaderWidget(professional: widget.professional),
              const SizedBox(height: 24),

              const Text(
                'Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _cancellationReasons.map((reason) {
                  return ReportReasonButton(
                    text: reason,
                    isSelected: _selectedReason == reason,
                    onTap: () {
                      setState(() {
                        _selectedReason = _selectedReason == reason
                            ? null
                            : reason;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text(
                'Payments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),

              PaymentTransactionItem(
                isCompleted: true,
                title: 'Bank transfer withdrawal',
                date: '3 jan 2025',
                transactionId: 'WD-2024-003',
                amount: 'S/${refundAmount.toStringAsFixed(2)}',
                buttonText: 'Pay',
                showButton: true,
              ),

              PaymentTransactionItem(
                isCompleted: false,
                title: 'Bank transfer withdrawal',
                date: '4 jan 2025',
                transactionId: 'WD-2024-003',
                amount: 'S/${pendingRefund.toStringAsFixed(2)}',
                buttonText: 'Refund',
                showButton: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedReason == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a cancellation reason'),
                          backgroundColor: Color(0xFFE53935),
                        ),
                      );
                      return;
                    }
                    _showCancellationConfirmation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4169E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Finish Job and Refund',
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
    );
  }

  void _showCancellationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm Cancellation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to cancel this job?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Reason: $_selectedReason',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF4169E1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You will receive a refund shortly.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Keep Job',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          print(
                            '🔴 Enviando CancelActiveJob desde confirmación',
                          );
                          context.read<ProcessBloc>().add(
                            CancelActiveJob(
                              widget.job.id,
                              _selectedReason ?? '',
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel Job',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

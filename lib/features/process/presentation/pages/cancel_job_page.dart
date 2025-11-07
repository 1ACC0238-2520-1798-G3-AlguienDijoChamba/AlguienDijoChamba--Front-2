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

  const CancelJobPage({
    Key? key,
    required this.professional,
    required this.job,
  }) : super(key: key);

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
    final double refundAmount = widget.job.totalCost / 2 * 0.5; // 90% de lo adelantado
    final double pendingRefund = widget.job.totalCost / 2 * 0.5; // 10% en espera

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
      body: BlocListener<ProcessBloc, ProcessState>(
        listener: (context, state) {
          if (state is JobCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job cancelled successfully')),
            );
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is ProcessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Professional Header
              ProfessionalHeaderWidget(professional: widget.professional),
              
              const SizedBox(height: 24),
              
              // Report Section
              const Text(
                'Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              
              // Cancellation Reason Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _cancellationReasons.map((reason) {
                  return ReportReasonButton(
                    text: reason,
                    isSelected: _selectedReason == reason,
                    onTap: () {
                      setState(() {
                        _selectedReason = _selectedReason == reason ? null : reason;
                      });
                    },
                  );
                }).toList(),
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
              
              // Primera transacción (reembolso procesado - flecha roja)
              PaymentTransactionItem(
                isCompleted: true,
                title: 'Bank transfer withdrawal',
                date: '3 jan 2025',
                transactionId: 'WD-2024-003',
                amount: 'S/${refundAmount.toStringAsFixed(2)}',
                buttonText: 'Pay',
                showButton: true,
              ),
              
              // Segunda transacción (reembolso pendiente - flecha azul)
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
              
              // Finish Job and Refund Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedReason == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a cancellation reason'),
                        ),
                      );
                      return;
                    }
                    
                    // Mostrar diálogo de confirmación
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to cancel this job?',
              ),
              const SizedBox(height: 12),
              Text(
                'Reason: $_selectedReason',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You will receive a refund shortly.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Job'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProcessBloc>().add(
                  CancelActiveJob(widget.job.id, _selectedReason ?? ''),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
              ),
              child: const Text('Cancel Job'),
            ),
          ],
        );
      },
    );
  }
}

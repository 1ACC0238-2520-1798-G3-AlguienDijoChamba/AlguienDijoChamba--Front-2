import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/process/domain/repositories/process_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../blocs/process_bloc.dart';
import '../widgets/professional_header_widget.dart';
import 'finish_review_page.dart';
import 'cancel_job_page.dart';


class ActiveJobPage extends StatelessWidget {
  final Professional professional;
  final Job job;
  final ProcessRepository repository;


  const ActiveJobPage({
    super.key,
    required this.professional,
    required this.job,
    required this.repository,
  });


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: injector<ProcessBloc>(),
      child: Scaffold(
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
              ProfessionalHeaderWidget(professional: professional),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.location_on, job.address),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.access_time, job.scheduledHour),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.calendar_today, _formatDate(job.scheduledDate)),
              const SizedBox(height: 24),
              const Text(
                'Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.additionalMessage?.isEmpty ?? true
                      ? 'No additional message'
                      : job.additionalMessage!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _finishJobWithBackend(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4169E1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Finish Job',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _cancelJobWithBackend(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4169E1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancel Job',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }


  // ✅ CORREGIDO: Navega directamente a FinishReviewPage sin hacer PATCH primero
  void _finishJobWithBackend(BuildContext context) {
    print('🔵 INICIO Finish Job - Navegando a FinishReviewPage');
    print('🔍 Job ID: ${job.id}');
    
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: injector<ProcessBloc>(),
            child: FinishReviewPage(
              professional: professional,
              job: job,
              repository: repository,
            ),
          ),
        ),
      );
    }
  }


  // ✅ Cancel Job permanece igual
  Future<void> _cancelJobWithBackend(BuildContext context) async {
    try {
      print('🔵 INICIO Cancel Job - Navegando directamente a Screen 7');
      print('🔍 Job ID: ${job.id}');
      print('🔍 Professional ID: ${professional.id}');

      if (context.mounted) {
        print('🔄 Navegando a CancelJobPage sin modal');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: injector<ProcessBloc>(),
              child: CancelJobPage(
                professional: professional,
                job: job,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Exception Cancel Job: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4169E1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ),
      ],
    );
  }


  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];

    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

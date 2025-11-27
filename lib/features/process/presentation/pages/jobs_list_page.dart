import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/job.dart';
import '../../domain/entities/professional.dart';
import '../../domain/repositories/process_repository.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import 'active_job_page.dart';

class JobsListPage extends StatefulWidget {
  final ProcessRepository repository;

  const JobsListPage({super.key, required this.repository});

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProcessBloc>().add(const LoadAvailableJobs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Jobs',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<ProcessBloc, ProcessState>(
        builder: (context, state) {
          print('DEBUG JobsListPage state: $state'); 
          if (state is ProcessLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProcessError) {
            return Center(child: Text(state.message));
          }

          if (state is JobsLoaded) {
            if (state.jobs.isEmpty) {
              return const Center(child: Text('No jobs found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                return _buildJobTile(context, job);
              },
            );
          }

          return const Center(child: Text('Sin jobs ni estado conocido'));
        },
      ),
    );
  }

  Widget _buildJobTile(BuildContext context, Job job) {
    final statusText = job.status;
    final statusColor = _statusColor(job.status);

    return InkWell(
      onTap: () async {
        final professional = Professional(
          id: job.professionalId,
          fullName: job.professionalName ?? job.specialty,
          email: '',
          phoneNumber: '',
          gender: '',
          rating: 0,
          reviewCount: 0,
          distance: 0,
          profileImage: '',
          badgeLevel: '',
          specialties: const [],
          availability: const {},
          hourlyRate: job.totalCost,
        );

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BlocProvider.value(
              value: context.read<ProcessBloc>(),
              child: ActiveJobPage(
                professional: professional,
                job: job,
                repository: widget.repository,
              ),
            ),
          ),
        );

        // 👉 Si desde FinishReview/CancelJob se devolvió 'job_updated',
        // recargamos la lista
        if (result == 'job_updated' && context.mounted) {
          context.read<ProcessBloc>().add(const LoadAvailableJobs());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del técnico
                  Text(
                    job.professionalName?.isNotEmpty == true
                        ? job.professionalName!
                        : job.specialty,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Prioridad
                  Text(
                    job.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Dirección
                  Text(
                    job.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Job ID
                  Text(
                    'Job ID: ${job.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chip de estado
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mantén esta función tal cual
Color _statusColor(String status) {
  switch (status) {
    case 'Accepted':
      return Colors.green;
    case 'Completed':
      return Colors.lightBlue;
    case 'Cancelled':
      return Colors.red;
    default:
      return const Color(0xFF6B7280);
  }
}

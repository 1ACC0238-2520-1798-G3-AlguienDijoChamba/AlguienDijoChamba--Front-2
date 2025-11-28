import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/process_repository.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import '../widgets/professional_header_widget.dart';
import 'request_job_page.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';

class ProfessionalDetailPage extends StatefulWidget {
  final String professionalId;

  const ProfessionalDetailPage({
    Key? key,
    required this.professionalId,
  }) : super(key: key);

  @override
  State<ProfessionalDetailPage> createState() => _ProfessionalDetailPageState();
}

class _ProfessionalDetailPageState extends State<ProfessionalDetailPage> {
  @override
  void initState() {
    super.initState();
    print('📄 INICIANDO: professionalId = ${widget.professionalId}');

    // ✅ AQUÍ YA HAY UN ProcessBloc PROVISTO
    try {
      context.read<ProcessBloc>().add(
            LoadProfessionalDetail(widget.professionalId),
          );
    } catch (e) {
      print('❌ ERROR AL CARGAR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<ProcessBloc, ProcessState>(
        listener: (context, state) {
          if (state is ProcessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Mostrar loading
          if (state is ProcessLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostrar datos cuando están cargados
          if (state is ProfessionalLoaded) {
            final professional = state.professional;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta principal con header del profesional
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ProfessionalHeaderWidget(
                        professional: professional,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Professional details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.person,
                            'Full name',
                            professional.fullName,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.work,
                            'Specialty',
                            professional.specialties.isNotEmpty
                                ? professional.specialties.first
                                : 'N/A',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.email,
                            'Email',
                            professional.email,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone',
                            professional.phoneNumber,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.badge,
                            'Gender',
                            professional.gender,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Weekdays',
                            'Monday - Tuesday - Wednesday - Thursday - Friday',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today_outlined,
                            'Weekend',
                            'Saturday - Sunday',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ✨ ARREGLADO: Pasar ProcessRepository a RequestJobPage
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final repository = injector<ProcessRepository>();

                        // ✅ REUSAR EL MISMO ProcessBloc EN RequestJobPage
                        final currentBloc = context.read<ProcessBloc>();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider<ProcessBloc>.value(
                              value: currentBloc,
                              child: RequestJobPage(
                                professional: professional,
                                repository: repository,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4169E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Hire now',
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
            );
          }

          // Estado por defecto (sin datos)
          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }

  // Versión mejorada: título + valor
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4169E1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

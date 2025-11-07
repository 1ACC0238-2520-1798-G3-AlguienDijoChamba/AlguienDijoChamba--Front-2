import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import '../widgets/professional_header_widget.dart';
import 'request_job_page.dart';
import '../../../../core/di/injector.dart';
import '../../domain/repositories/process_repository.dart';  // ✨ NUEVO


class ProfessionalDetailPage extends StatefulWidget {
  final String professionalId;

  const ProfessionalDetailPage({Key? key, required this.professionalId})
    : super(key: key);

  @override
  State<ProfessionalDetailPage> createState() => _ProfessionalDetailPageState();
}


class _ProfessionalDetailPageState extends State<ProfessionalDetailPage> {
  @override
  void initState() {
    super.initState();
    print('📄 INICIANDO: professionalId = ${widget.professionalId}');

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
                  // Professional Header
                  ProfessionalHeaderWidget(professional: professional),

                  const SizedBox(height: 24),

                  // Description Section
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Full Name
                  _buildInfoRow(Icons.person, professional.fullName),
                  const SizedBox(height: 12),

                  // Profession
                  _buildInfoRow(
                    Icons.work,
                    professional.specialties.isNotEmpty
                        ? professional.specialties.first
                        : 'N/A',
                  ),
                  const SizedBox(height: 12),

                  // Email
                  _buildInfoRow(Icons.email, professional.email),
                  const SizedBox(height: 12),

                  // Phone
                  _buildInfoRow(Icons.phone, professional.phoneNumber),
                  const SizedBox(height: 12),

                  // Gender
                  _buildInfoRow(Icons.badge, professional.gender),
                  const SizedBox(height: 12),

                  // Availability - Weekdays
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Monday - Tuesday - Wednesday - Thursday - Friday',
                  ),
                  const SizedBox(height: 12),

                  // Availability - Weekend
                  _buildInfoRow(Icons.calendar_today, 'Saturday - Sunday'),

                  const SizedBox(height: 32),

                  // ✨ ARREGLADO: Pasar ProcessRepository a RequestJobPage
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final repository = injector<ProcessRepository>();  // ✨ OBTENER DEL INJECTOR
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<ProcessBloc>.value(
                                  value: injector<ProcessBloc>(),
                                ),
                              ],
                              child: RequestJobPage(
                                professional: professional,
                                repository: repository,  // ✨ PASAR REPOSITORY
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

          // Mostrar error
          if (state is ProcessError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProcessBloc>().add(
                        LoadProfessionalDetail(widget.professionalId),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado inicial
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF757575), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF424242)),
            ),
          ),
        ],
      ),
    );
  }
}

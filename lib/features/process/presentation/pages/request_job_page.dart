import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/professional.dart';
import '../../domain/repositories/process_repository.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import '../widgets/professional_header_widget.dart';
import '../widgets/job_category_chip.dart';
import 'payment_page.dart';


class RequestJobPage extends StatefulWidget {
  final Professional professional;
  final ProcessRepository repository;

  const RequestJobPage({
    Key? key,
    required this.professional,
    required this.repository,
  }) : super(key: key);

  @override
  State<RequestJobPage> createState() => _RequestJobPageState();
}

class _RequestJobPageState extends State<RequestJobPage> {
  final _addressController = TextEditingController();
  final _hourController = TextEditingController();
  final _dateController = TextEditingController();
  final _messageController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime; // <-- NUEVO: para guardar la hora

  String _selectedPaymentMethod = 'Credit/Debit Card';
  final List<String> _selectedCategories = ['High Priority'];

  final List<Map<String, dynamic>> _categories = [
    {'label': 'High Priority', 'color': const Color(0xFFB2DFDB)},
    {'label': 'Plumbing', 'color': const Color(0xFFBBDEFB)},
    {'label': 'Home', 'color': const Color(0xFFD1C4E9)},
    {'label': 'Maintenance', 'color': const Color(0xFFFFECB3)},
  ];

  @override
  Widget build(BuildContext context) {
    print('🔍 DEBUG Professional Data:');
    print('   - ID: ${widget.professional.id}');
    print('   - Name: ${widget.professional.fullName}');
    print('   - Specialty: ${widget.professional.specialties}');

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
          if (state is JobCreated) {
            // ✅ Reusar el mismo ProcessBloc para PaymentPage
            final currentBloc = context.read<ProcessBloc>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<ProcessBloc>.value(
                  value: currentBloc,
                  child: PaymentPage(
                    professional: widget.professional,
                    job: state.job,
                    repository: widget.repository,
                  ),
                ),
              ),
            );
          } else if (state is ProcessError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfessionalHeaderWithRate(),
                const SizedBox(height: 24),
                const Text(
                  'Job',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._categories.map(
                      (category) => JobCategoryChip(
                        label: category['label'],
                        backgroundColor: category['color'],
                        isSelected:
                            _selectedCategories.contains(category['label']),
                        onTap: () {
                          setState(() {
                            if (_selectedCategories
                                .contains(category['label'])) {
                              _selectedCategories.remove(category['label']);
                            } else {
                              _selectedCategories.add(category['label']);
                            }
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add more categories logic
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4169E1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPaymentMethodCard(
                        'Credit/Debit Card',
                        Icons.credit_card,
                        _selectedPaymentMethod == 'Credit/Debit Card',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPaymentMethodCard(
                        'Digital Wallet',
                        Icons.account_balance_wallet,
                        _selectedPaymentMethod == 'Digital Wallet',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  'Address',
                  Icons.location_on,
                  _addressController,
                ),
                const SizedBox(height: 16),
                _buildTextField('Hour', Icons.access_time, _hourController),
                const SizedBox(height: 16),
                _buildDatePickerField(),
                const SizedBox(height: 16),
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitJobRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4169E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Request Job',
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
        },
      ),
    );
  }

  Widget _buildProfessionalHeaderWithRate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProfessionalHeaderWidget(
            professional: widget.professional,
            showEmail: false,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // --- CORRECCIÓN IMAGEN 3: Mostrar precio del técnico ---
                Text(
                  'S/${widget.professional.hourlyRate.toStringAsFixed(2)}/hr', // <-- USA EL VALOR REAL
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                // ---------------------------------------------------
                const Text(
                  'Starting rate',
                  style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF4169E1), width: 2)
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color:
                  isSelected ? const Color(0xFF4169E1) : const Color(0xFF757575),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? const Color(0xFF4169E1)
                    : const Color(0xFF757575),
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            prefixIcon: Icon(icon, color: const Color(0xFF757575)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                _dateController.text =
                    '${picked.day}/${picked.month}/${picked.year}';
              });
            }
          },
          child: TextField(
            controller: _dateController,
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Select a date',
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF757575),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitJobRequest() async {
    // 1. Validaciones visuales
    if (_addressController.text.isEmpty ||
        _hourController.text.isEmpty ||
        _selectedDate == null ||
        _selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final scheduledDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final jobData = {
      'professionalId': widget.professional.id.toString(),
      'customerId': widget.professional.id.toString(),
      'specialty': widget.professional.specialties.isNotEmpty
          ? widget.professional.specialties.first
          : 'General',
      'description': _selectedCategories.join(', '),
      'address': _addressController.text,
      'scheduledDate': scheduledDateTime.toIso8601String(),
      'scheduledHour': _hourController.text,
      'categories': _selectedCategories,
      'paymentMethod': _selectedPaymentMethod,
      'additionalMessage': _messageController.text,
      'totalCost': widget.professional.hourlyRate * 2,
    };

    print('📊 JOB DATA: $jobData');
    
    // Enviar evento al Bloc
    context.read<ProcessBloc>().add(CreateJob(jobData));
  }


  @override
  void dispose() {
    _addressController.dispose();
    _hourController.dispose();
    _dateController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

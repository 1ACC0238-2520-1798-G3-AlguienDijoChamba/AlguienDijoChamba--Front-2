import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/professional.dart';
import '../../domain/entities/job.dart';
import '../blocs/process_bloc.dart';
import '../blocs/process_event.dart';
import '../blocs/process_state.dart';
import '../widgets/professional_header_widget.dart';
import '../widgets/star_rating_widget.dart';
import '../widgets/job_category_chip.dart';

class FinishReviewPage extends StatefulWidget {
  final Professional professional;
  final Job job;

  const FinishReviewPage({
    Key? key,
    required this.professional,
    required this.job,
  }) : super(key: key);

  @override
  State<FinishReviewPage> createState() => _FinishReviewPageState();
}

class _FinishReviewPageState extends State<FinishReviewPage> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'High Priority', 'color': const Color(0xFFB2DFDB)},
    {'label': 'Plumbing', 'color': const Color(0xFFBBDEFB)},
    {'label': 'Home', 'color': const Color(0xFFD1C4E9)},
    {'label': 'Maintenance', 'color': const Color(0xFFFFECB3)},
  ];

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
      body: BlocListener<ProcessBloc, ProcessState>(
        listener: (context, state) {
          if (state is JobCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Review submitted successfully')),
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
              
              // Description Section - Job Categories
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              
              // Job Category Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.job.categories.map((category) {
                  final categoryData = _categories.firstWhere(
                    (cat) => cat['label'] == category,
                    orElse: () => {
                      'label': category,
                      'color': const Color(0xFFFFECB3)
                    },
                  );
                  
                  return JobCategoryChip(
                    label: category,
                    backgroundColor: categoryData['color'],
                    isSelected: false,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Star Rating Section
              const Text(
                'Rating',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 16),
              
              // Stars (0-5)
              StarRatingWidget(
                maxRating: 5,
                onRatingChanged: (rating) {
                  setState(() {
                    _selectedRating = rating;
                  });
                },
                initialRating: _selectedRating,
              ),
              
              const SizedBox(height: 24),
              
              // Message Section
              const Text(
                'Message',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Finish Review Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedRating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a rating'),
                        ),
                      );
                      return;
                    }
                    
                    context.read<ProcessBloc>().add(
                      FinishJob(
                        widget.job.id,
                        _selectedRating,
                        _reviewController.text,
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
                    'Finish Review',
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

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}

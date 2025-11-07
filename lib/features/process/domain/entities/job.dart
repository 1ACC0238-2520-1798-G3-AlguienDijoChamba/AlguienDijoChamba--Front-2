// lib/features/process/domain/entities/job.dart

class Job {
  final String id;
  final String clientId;
  final String professionalId;
  final String specialty;          // ✨ NUEVO
  final String description;        // ✨ NUEVO
  final String address;
  final DateTime scheduledDate;
  final String scheduledHour;
  final String? additionalMessage;
  final List<String> categories;   // ✨ NUEVO
  final String paymentMethod;
  final double totalCost;

  Job({
    required this.id,
    required this.clientId,
    required this.professionalId,
    required this.specialty,        // ✨ NUEVO
    required this.description,      // ✨ NUEVO
    required this.address,
    required this.scheduledDate,
    required this.scheduledHour,
    this.additionalMessage,
    required this.categories,       // ✨ NUEVO
    required this.paymentMethod,
    required this.totalCost,
  });
}

class Job {
  final String id;
  final String clientId;
  final String professionalId;
  final String specialty;
  final String description;
  final String address;
  final DateTime scheduledDate;
  final String scheduledHour;
  final String? additionalMessage;
  final List<String> categories;
  final String paymentMethod;
  final double totalCost;
  final String status;

  // 👇 NUEVO: nombre del técnico
  final String? professionalName;

  Job({
    required this.id,
    required this.clientId,
    required this.professionalId,
    required this.specialty,
    required this.description,
    required this.address,
    required this.scheduledDate,
    required this.scheduledHour,
    this.additionalMessage,
    required this.categories,
    required this.paymentMethod,
    required this.totalCost,
    required this.status,
    this.professionalName,
  });
}

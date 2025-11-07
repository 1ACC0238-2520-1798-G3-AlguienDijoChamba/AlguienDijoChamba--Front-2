class Job {
  final String id;
  final String professionalId;
  final String customerId;
  final String address;
  final DateTime scheduledDate;
  final String scheduledHour;
  final List<String> categories;
  final String paymentMethod;
  final String additionalMessage;
  final double totalCost;
  final String status;

  Job({
    required this.id,
    required this.professionalId,
    required this.customerId,
    required this.address,
    required this.scheduledDate,
    required this.scheduledHour,
    required this.categories,
    required this.paymentMethod,
    required this.additionalMessage,
    required this.totalCost,
    required this.status,
  });
}

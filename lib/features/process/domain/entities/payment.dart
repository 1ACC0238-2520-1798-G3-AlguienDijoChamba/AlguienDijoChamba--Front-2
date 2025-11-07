class Payment {
  final String id;
  final String jobId;
  final double amount;
  final String type;
  final String status;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.jobId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });
}

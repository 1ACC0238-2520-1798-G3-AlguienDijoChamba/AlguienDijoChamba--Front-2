// lib/features/process/data/models/payment_model.dart

import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  PaymentModel({
    required super.id,
    required super.jobId,
    required super.amount,
    required super.type,
    required super.status,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      jobId: json['jobId']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'amount': amount,
      'type': type,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// lib/features/process/data/models/job_model.dart

import '../../domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.professionalId,
    required super.customerId,
    required super.address,
    required super.scheduledDate,
    required super.scheduledHour,
    required super.categories,
    required super.paymentMethod,
    required super.additionalMessage,
    required super.totalCost,
    required super.status,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id']?.toString() ?? '',
      professionalId: json['professionalId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      address: json['address'] ?? '',
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? DateTime.now().toIso8601String()),
      scheduledHour: json['scheduledHour'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      paymentMethod: json['paymentMethod'] ?? '',
      additionalMessage: json['additionalMessage'] ?? '',
      totalCost: (json['totalCost'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'professionalId': professionalId,
      'customerId': customerId,
      'address': address,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledHour': scheduledHour,
      'categories': categories,
      'paymentMethod': paymentMethod,
      'additionalMessage': additionalMessage,
      'totalCost': totalCost,
      'status': status,
    };
  }
}

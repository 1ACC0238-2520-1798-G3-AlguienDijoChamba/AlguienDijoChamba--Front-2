// lib/features/process/data/models/job_model.dart

import '../../domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required String id,
    required String clientId,
    required String professionalId,
    required String specialty,
    required String description,
    required String address,
    required DateTime scheduledDate,
    required String scheduledHour,
    String? additionalMessage,
    required List<String> categories,
    required String paymentMethod,
    required double totalCost,
  }) : super(
    id: id,
    clientId: clientId,
    professionalId: professionalId,
    specialty: specialty,
    description: description,
    address: address,
    scheduledDate: scheduledDate,
    scheduledHour: scheduledHour,
    additionalMessage: additionalMessage,
    categories: categories,
    paymentMethod: paymentMethod,
    totalCost: totalCost,
  );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    print('🔍 JobModel.fromJson recibido: $json');
    
    return JobModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? 'unknown_${DateTime.now().millisecondsSinceEpoch}',
      clientId: json['clientId'] as String? ?? json['customerId'] as String? ?? '',
      professionalId: json['professionalId'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      scheduledDate: json['scheduledDate'] != null 
        ? DateTime.parse(json['scheduledDate'] as String)
        : DateTime.now(),
      scheduledHour: json['scheduledHour'] as String? ?? '',
      additionalMessage: json['additionalMessage'] as String?,
      categories: List<String>.from(json['categories'] as List<dynamic>? ?? []),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'professionalId': professionalId,
      'specialty': specialty,
      'description': description,
      'address': address,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledHour': scheduledHour,
      'additionalMessage': additionalMessage,
      'categories': categories,
      'paymentMethod': paymentMethod,
      'totalCost': totalCost,
    };
  }
}

import '../models/professional_model.dart';

class ProcessMockDataSource {
  // Simula obtener un profesional por ID
  Future<ProfessionalModel> getProfessionalById(String id) async {
    // Simula delay de red
    await Future.delayed(const Duration(seconds: 1));
    
    // Retorna datos mock
    return ProfessionalModel.mock();
  }

  // Simula crear un trabajo
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'id': 'job_123',
      'status': 'PENDING',
      'message': 'Job created successfully',
    };
  }

  // Simula procesar pago
  Future<Map<String, dynamic>> processPayment(Map<String, dynamic> paymentData) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'id': 'payment_456',
      'status': 'COMPLETED',
      'message': 'Payment processed successfully',
    };
  }
}

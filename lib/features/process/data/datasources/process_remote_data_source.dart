// lib/features/process/data/datasources/process_remote_data_source.dart

import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import '../models/professional_model.dart';
import '../models/job_model.dart';
import '../models/payment_model.dart';

class ProcessRemoteDataSource {
  final ApiClient apiClient;

  ProcessRemoteDataSource({required this.apiClient});

  /// Obtener detalles del profesional por ID
  /// GET /professionals/{id}
  Future<ProfessionalModel> getProfessionalById(String id) async {
    try {
      print('🔵 FETCH: Obteniendo profesional con ID: $id');
      
      final response = await apiClient.get(
        '/professionals/$id',  // ✅ SIN /api/v1
        requiresAuth: true,
      );
      
      print('✅ RESPONSE RECIBIDA: $response');
      
      final model = ProfessionalModel.fromJson(response as Map<String, dynamic>);
      print('✅ MODELO MAPEADO: ${model.fullName}');
      
      return model;
    } catch (e) {
      print('❌ ERROR FETCH: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      throw Exception('Failed to fetch professional: $e');
    }
  }

  /// Crear solicitud de trabajo
  /// POST /jobs/request
  Future<JobModel> createJobRequest(Map<String, dynamic> jobData) async {
    try {
      final response = await apiClient.post(
        '/jobs/request',  // ✅ SIN /api/v1
        body: jobData,
        requiresAuth: true,
      );
      return JobModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create job request: $e');
    }
  }

  /// Procesar pago
  /// POST /payments/process
  Future<PaymentModel> processPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await apiClient.post(
        '/payments/process',  // ✅ SIN /api/v1
        body: paymentData,
        requiresAuth: true,
      );
      return PaymentModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  /// Completar trabajo (enviar review)
  /// POST /reputation/initial
  Future<void> completeJob(
    String jobId,
    int rating,
    String review,
  ) async {
    try {
      await apiClient.post(
        '/reputation/initial',  // ✅ SIN /api/v1
        body: {
          'jobId': jobId,
          'rating': rating,
          'review': review,
        },
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to complete job: $e');
    }
  }

  /// Cancelar trabajo
  /// POST /jobs/{jobId}/cancel
  Future<void> cancelJob(String jobId, String reason) async {
    try {
      await apiClient.post(
        '/jobs/$jobId/cancel',  // ✅ SIN /api/v1
        body: {'reason': reason},
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to cancel job: $e');
    }
  }

  /// Obtener balance disponible (opcional)
  /// GET /payments/balance
  Future<Map<String, dynamic>> getAvailableBalance() async {
    try {
      final response = await apiClient.get(
        '/payments/balance',  // ✅ SIN /api/v1
        requiresAuth: true,
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch balance: $e');
    }
  }
}

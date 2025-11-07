import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import '../models/job_model.dart';
import '../models/professional_model.dart';


class ProcessRemoteDataSource {
  final ApiClient apiClient;


  ProcessRemoteDataSource({required this.apiClient});


  Future<ProfessionalModel> getProfessionalById(String professionalId) async {
    final response = await apiClient.get('/professionals/$professionalId', requiresAuth: true);
    return ProfessionalModel.fromJson(response);
  }


  Future<JobModel> createJobRequest(Map<String, dynamic> params) async {
    final response = await apiClient.post(
      '/jobs/request',
      body: params,
      requiresAuth: true,
    );
    return JobModel.fromJson(response);
  }


  Future<List<JobModel>> getAvailableJobs() async {
    final response = await apiClient.get('/jobs/available', requiresAuth: true);
    if (response is List) {
      return response.map((job) => JobModel.fromJson(job as Map<String, dynamic>)).toList();
    }
    return [];
  }


  Future<JobModel> saveActiveJob(Map<String, dynamic> jobData) async {
    final response = await apiClient.post(
      '/jobs/active',
      body: jobData,
      requiresAuth: true,
    );
    return JobModel.fromJson(response);
  }


  Future<JobModel?> getActiveJob(String clientId) async {
    try {
      final response = await apiClient.get(
        '/jobs/active/customer/$clientId',
        requiresAuth: true,
      );
      if (response == null) return null;
      return JobModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }


  Future<void> updateJobStatus(String jobId, String status) async {
    await apiClient.patch(
      '/jobs/$jobId/status',
      body: {'status': status},
      requiresAuth: true,
    );
  }


  Future<JobModel> getJobById(String jobId) async {
    final response = await apiClient.get(
      '/jobs/$jobId',
      requiresAuth: true,
    );
    return JobModel.fromJson(response);
  }


  Future<void> completeJob(String jobId, int rating, String review) async {
    await apiClient.post(
      '/reputation/initial',
      body: {
        'jobId': jobId,
        'rating': rating,
        'review': review,
      },
      requiresAuth: true,
    );
  }


  // ✅ CORREGIDO: Cambiar de /cancel a /status con PATCH
  Future<void> cancelJob(String jobId, String reason) async {
    print('🔧 API CLIENT: Cancelando job $jobId con PATCH a /status');
    await apiClient.patch(
      '/jobs/$jobId/status',
      body: {'status': 'Cancelled'},
      requiresAuth: true,
    );
  }
}

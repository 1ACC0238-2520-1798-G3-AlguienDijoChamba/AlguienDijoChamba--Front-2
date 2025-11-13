import 'dart:async';
import 'package:signalr_core/signalr_core.dart';
import 'package:alguiendijochamba_app_flutter/core/constants.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_event.dart';

class SignalRService {
  final TokenStorage tokenStorage;
  final ProcessBloc processBloc;
  HubConnection? _hubConnection;

  // Extrae la URL base (ej. http://10.0.2.2:5000)
  final String _baseUrl = BASE_URL.replaceAll('/api/v1', '');
  
  SignalRService({
    required this.tokenStorage,
    required this.processBloc,
  });

  Future<void> connect() async {
    if (_hubConnection != null && _hubConnection!.state == HubConnectionState.connected) {
      print('SignalR (Cliente) ya está conectado.');
      return;
    }
    
    final token = await tokenStorage.getToken();
    if (token == null) {
      print('SignalR (Cliente) Error: No hay token, no se puede conectar.');
      return;
    }

    final hubUrl = '$_baseUrl/hubs/servicerequests';
    print('SignalR (Cliente): Conectando a $hubUrl...');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect()
        .build();

    // --- ESCUCHA LOS EVENTOS DEL SERVIDOR ---
    
    // 1. El Técnico (Android) ACEPTÓ
    _hubConnection!.on('RequestAccepted', (arguments) {
      print('🚀 SIGNALR (Cliente): RECIBIDO EVENTO RequestAccepted');
      print('📦 Argumentos crudos: $arguments');

      if (arguments != null && arguments.isNotEmpty) {
        try {
          // .NET suele enviar el objeto como un Map en la primera posición
          final data = arguments[0] as Map<String, dynamic>;
          print('📦 Datos decodificados: $data');

          // LEER CON SEGURIDAD (Maneja Mayúsculas o Minúsculas)
          final jobId = (data['jobId'] ?? data['JobId'])?.toString() ?? '';
          final professionalId = (data['professionalId'] ?? data['ProfessionalId'])?.toString() ?? '';
          
          // Manejo seguro de números (int o double)
          final costRaw = data['proposedCost'] ?? data['ProposedCost'];
          final proposedCost = (costRaw is int) ? costRaw.toDouble() : (costRaw as double?);

          print('✅ Parseo Exitoso -> JobId: $jobId, Costo: $proposedCost');

          // Notifica al BLoC
          processBloc.add(JobStatusUpdatedByHub(
            jobId: jobId, 
            status: "Accepted", 
            professionalId: professionalId,
            proposedCost: proposedCost
          ));
        } catch (e) {
          print('❌ ERROR PARSEANDO DATA SIGNALR: $e');
        }
      }
    });
    // 2. El Técnico (Android) RECHAZÓ
    _hubConnection!.on('RequestDeclined', (arguments) {
      print('SignalR (Cliente): ¡Solicitud Rechazada! $arguments');
      if (arguments != null && arguments.isNotEmpty) {
        final jobId = arguments[0] as String;
        processBloc.add(JobStatusUpdatedByHub(jobId: jobId, status: "Declined"));
      }
    });
    
    // (Puedes añadir más listeners aquí, como 'JobCompletedByTechnician')

    try {
      await _hubConnection!.start();
      print('SignalR (Cliente): Conectado exitosamente.');
    } catch (e) {
      print('SignalR (Cliente): Error al conectar: $e');
    }
  }

  void disconnect() {
    _hubConnection?.stop();
    print('SignalR (Cliente): Desconectado.');
  }
}
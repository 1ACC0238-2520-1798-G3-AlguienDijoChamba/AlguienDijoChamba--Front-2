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
      print('SignalR (Cliente): ¡Solicitud Aceptada! $arguments');
      if (arguments != null && arguments.isNotEmpty) {
        final jobId = arguments[0] as String;
        final professionalId = arguments[1] as String;
        // Notifica al BLoC para que la UI reaccione
        processBloc.add(JobStatusUpdatedByHub(jobId: jobId, status: "Accepted", professionalId: professionalId));
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
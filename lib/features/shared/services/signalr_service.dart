import 'package:signalr_core/signalr_core.dart';
import 'package:alguiendijochamba_app_flutter/core/constants.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/process/presentation/blocs/process_event.dart';

class SignalRService {
  final TokenStorage tokenStorage;
  final ProcessBloc processBloc;
  HubConnection? _hubConnection;

  // Asegúrate de que apunte a tu IP local, no localhost para Android Emulador
  final String _hubUrl = '${BASE_URL.replaceAll('/api/v1', '')}/hubs/servicerequests';

  SignalRService({
    required this.tokenStorage,
    required this.processBloc,
  });

  Future<void> connect() async {
    final token = await tokenStorage.getToken();
    if (token == null) return;

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async => token,
            logging: (level, message) => print('SignalR Log: $message'),
          ),
        )
        .withAutomaticReconnect()
        .build();

    // 1. 🎧 ESCUCHAR RESPUESTA "ACEPTADA" DE ANDROID
    _hubConnection!.on('RequestAccepted', (arguments) {
      print('🚀 FLUTTER: ¡El técnico aceptó la solicitud!');
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        
        processBloc.add(JobStatusUpdatedByHub(
          jobId: data['JobId'].toString(),
          status: "Accepted",
          professionalId: data['ProfessionalId'].toString(),
          proposedCost: (data['ProposedCost'] as num).toDouble(),
        ));
      }
    });

    // 2. 🎧 ESCUCHAR RESPUESTA "RECHAZADA" DE ANDROID
    _hubConnection!.on('RequestDeclined', (arguments) {
      print('😔 FLUTTER: El técnico rechazó la solicitud.');
      if (arguments != null && arguments.isNotEmpty) {
        // En .NET enviamos un objeto anónimo, revisa la estructura
        // Si enviaste responsePayload, es el primer argumento
        final data = arguments[0] as Map<String, dynamic>;
        processBloc.add(JobStatusUpdatedByHub(
          jobId: data['JobId'].toString(), 
          status: "Declined"
        ));
      }
    });

    try {
      await _hubConnection!.start();
      print('✅ Flutter SignalR Conectado. ID: ${_hubConnection?.connectionId}');
    } catch (e) {
      print('❌ Flutter SignalR Error: $e');
    }
  }
}
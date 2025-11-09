import 'package:signalr_netcore/signalr_client.dart';
import 'dart:async';

class ChatSignalRDataSource {
  late HubConnection _connection;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  /// Conexión con el Hub en tu backend
  Future<void> connect() async {
    final serverUrl = "http://192.168.1.19:5000/chatHub";
    _connection = HubConnectionBuilder().withUrl(serverUrl).build();

    // Escuchar mensajes entrantes del servidor
    _connection.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = Map<String, dynamic>.from(arguments[0] as Map);
        _controller.add(data);
      }
    });

    await _connection.start();
    print("✅ Conectado al ChatHub de SignalR");
  }

  /// Envía mensaje al servidor
  Future<void> sendMessage(Map<String, dynamic> message) async {
    await _connection.invoke("SendMessage", args: [
      message['senderId'],
      message['receiverId'],
      message['content']
    ]);
  }

  /// Escucha los mensajes entrantes (stream)
  Stream<Map<String, dynamic>> listenMessages() => _controller.stream;

  /// Desconecta del hub
  Future<void> disconnect() async {
    await _connection.stop();
    await _controller.close();
  }
}

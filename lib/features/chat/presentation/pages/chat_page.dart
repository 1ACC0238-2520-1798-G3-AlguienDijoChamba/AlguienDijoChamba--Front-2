import 'package:flutter/material.dart';
import '../../data/datasources/chat_signalr_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/message_entity.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  final String myId = "cliente1"; // tu ID (puedes obtenerlo del login)
  final String receiverId = "tecnico1"; // ID del técnico

  late ChatRepositoryImpl repo;

  @override
  void initState() {
    super.initState();
    // Inicializamos el repositorio SignalR
    repo = ChatRepositoryImpl(ChatSignalRDataSource());

    _connectChat();
  }

  Future<void> _connectChat() async {
    await repo.connect();
    print("✅ Conectado al ChatHub (SignalR)");

    // Escucha los mensajes entrantes
    repo.receiveMessages().listen((message) {
      setState(() {
        _messages.add({
          'text': message.content,
          'isMe': message.senderId == myId,
        });
      });
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = MessageEntity(
      senderId: myId,
      receiverId: receiverId,
      content: text,
      timestamp: DateTime.now(),
    );

    await repo.sendMessage(msg);

    setState(() {
      _messages.add({'text': text, 'isMe': true});
    });

    _controller.clear();
  }

  @override
  void dispose() {
    repo.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat con Técnico')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg['text']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

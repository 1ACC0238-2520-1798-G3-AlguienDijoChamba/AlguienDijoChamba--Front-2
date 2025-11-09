import '../entities/message_entity.dart';

/// Interfaz abstracta que define qué puede hacer el chat.
/// La implementará el `ChatRepositoryImpl` en la capa de datos.
abstract class ChatRepository {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(MessageEntity message);
  Stream<MessageEntity> receiveMessages();
}

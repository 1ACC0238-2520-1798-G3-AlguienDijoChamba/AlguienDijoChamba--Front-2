import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_signalr_data_source.dart';
import '../models/message_model.dart';

/// Implementación concreta del repositorio que usa SignalR.
class ChatRepositoryImpl implements ChatRepository {
  final ChatSignalRDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<void> connect() async {
    await dataSource.connect();
  }

  @override
  Future<void> disconnect() async {
    await dataSource.disconnect();
  }

  @override
  Future<void> sendMessage(MessageEntity message) async {
    final model = MessageModel(
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
    );
    await dataSource.sendMessage(model.toJson());
  }

  @override
  Stream<MessageEntity> receiveMessages() {
    return dataSource.listenMessages().map((json) => MessageModel.fromJson(json));
  }
}

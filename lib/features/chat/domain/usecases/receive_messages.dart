import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class ReceiveMessages {
  final ChatRepository repository;
  ReceiveMessages(this.repository);

  Stream<MessageEntity> call() => repository.receiveMessages();
}

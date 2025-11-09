import '../repositories/chat_repository.dart';

class ConnectChat {
  final ChatRepository repository;
  ConnectChat(this.repository);

  Future<void> call() async => await repository.connect();
}

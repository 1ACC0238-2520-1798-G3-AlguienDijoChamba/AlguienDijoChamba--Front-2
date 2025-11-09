class MessageEntity {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  const MessageEntity({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });
}

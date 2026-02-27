class MessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final SenderInfo? senderInfo;

  MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.senderInfo,
  });
}

class SenderInfo {
  final String id;
  final String? username;
  final String? email;

  SenderInfo({required this.id, this.username, this.email});
}


import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final SenderInfoModel? senderInfo;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.senderInfo,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      conversationId: json['conversationId'] is String
          ? json['conversationId']
          : json['conversationId']?['_id'] ?? '',
      senderId: json['senderId'] is String
          ? json['senderId']
          : json['senderId']?['_id'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      senderInfo: json['senderId'] is Map
          ? SenderInfoModel.fromJson(json['senderId'])
          : null,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      isRead: isRead,
      createdAt: createdAt,
      senderInfo: senderInfo?.toEntity(),
    );
  }
}

class SenderInfoModel {
  final String id;
  final String? username;
  final String? email;

  SenderInfoModel({
    required this.id,
    this.username,
    this.email,
  });

  factory SenderInfoModel.fromJson(Map<String, dynamic> json) {
    return SenderInfoModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
    );
  }

  SenderInfo toEntity() {
    return SenderInfo(
      id: id,
      username: username,
      email: email,
    );
  }
}

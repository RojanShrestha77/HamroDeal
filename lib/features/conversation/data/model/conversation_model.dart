
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';

class ConversationModel {
  final String id;
  final String userId;
  final String sellerId;
  final int unreadCount;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfoModel? userInfo;
  final UserInfoModel? sellerInfo;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.unreadCount,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    this.userInfo,
    this.sellerInfo,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'],
      userId: json['userId'] is String
          ? json['userId']
          : json['userId']?['_id'] ?? '',
      sellerId: json['sellerId'] is String
          ? json['sellerId']
          : json['sellerId']?['_id'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userInfo: json['userId'] is Map
          ? UserInfoModel.fromJson(json['userId'])
          : null,
      sellerInfo: json['sellerId'] is Map
          ? UserInfoModel.fromJson(json['sellerId'])
          : null,
    );
  }

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      userId: userId,
      sellerId: sellerId,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userInfo: userInfo?.toEntity(),
      sellerInfo: sellerInfo?.toEntity(),
    );
  }
}

class UserInfoModel {
  final String id;
  final String? username;
  final String? email;
  final String? profileImage;

  UserInfoModel({
    required this.id,
    this.username,
    this.email,
    this.profileImage,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  UserInfo toEntity() {
    return UserInfo(
      id: id,
      username: username,
      email: email,
      profileImage: profileImage,
    );
  }
}

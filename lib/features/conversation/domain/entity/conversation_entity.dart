class ConversationEntity {
  final String id;
  final String userId;
  final String sellerId;
  final int unreadCount;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfo? userInfo;
  final UserInfo? sellerInfo;

  ConversationEntity({
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
}

class UserInfo {
  final String id;
  final String? username;
  final String? email;
  final String? profileImage;

  UserInfo({required this.id, this.username, this.email, this.profileImage});
}

import 'package:dartz/dartz.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';

abstract class IMessagingRepository {
  // Conversation methods
  Future<Either<ApiFailure, ConversationEntity>> createOrGetConversation(
    String sellerId,
  );

  Future<Either<ApiFailure, List<ConversationEntity>>> getAllConversations();

  Future<Either<ApiFailure, ConversationEntity>> getConversationById(String id);

  Future<Either<ApiFailure, void>> deleteConversation(String id);

  Future<Either<ApiFailure, void>> resetUnreadCount(String id);

  // Message methods
  Future<Either<ApiFailure, List<MessageEntity>>> getConversationMessages(
    String conversationId,
  );

  Future<Either<ApiFailure, MessageEntity>> sendMessage(
    String conversationId,
    String content,
  );

  Future<Either<ApiFailure, void>> deleteMessage(String id);

  Future<Either<ApiFailure, void>> markMessagesAsRead(String conversationId);
}

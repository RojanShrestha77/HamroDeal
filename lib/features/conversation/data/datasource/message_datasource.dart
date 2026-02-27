
import 'package:hamro_deal/features/conversation/data/model/conversation_model.dart';
import 'package:hamro_deal/features/conversation/data/model/message_model.dart';

abstract class IMessagingDataSource {
  // Conversation methods
  Future<ConversationModel> createOrGetConversation(String sellerId);
  
  Future<List<ConversationModel>> getAllConversations();
  
  Future<ConversationModel> getConversationById(String id);
  
  Future<void> deleteConversation(String id);
  
  Future<void> resetUnreadCount(String id);

  // Message methods
  Future<List<MessageModel>> getConversationMessages(String conversationId);
  
  Future<MessageModel> sendMessage(String conversationId, String content);
  
  Future<void> deleteMessage(String id);
  
  Future<void> markMessagesAsRead(String conversationId);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/create_or_get_conversation_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/delete_conversation_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/delete_message_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/get_all_conversations_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/get_conversation_by_id_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/get_conversation_messages_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/mark_messages_as_read_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/reset_unread_count_usecase.dart';
import 'package:hamro_deal/features/conversation/domain/usecases/send_message_usecase.dart';
import 'package:hamro_deal/features/conversation/presentation/state/messaging_state.dart';

final messagingViewModelProvider =
    NotifierProvider<MessagingViewModel, MessagingState>(
      () => MessagingViewModel(),
    );

class MessagingViewModel extends Notifier<MessagingState> {
  late final CreateOrGetConversationUsecase _createOrGetConversationUsecase;
  late final GetAllConversationsUsecase _getAllConversationsUsecase;
  late final GetConversationByIdUsecase _getConversationByIdUsecase;
  late final DeleteConversationUsecase _deleteConversationUsecase;
  late final ResetUnreadCountUsecase _resetUnreadCountUsecase;
  late final GetConversationMessagesUsecase _getConversationMessagesUsecase;
  late final SendMessageUsecase _sendMessageUsecase;
  late final DeleteMessageUsecase _deleteMessageUsecase;
  late final MarkMessagesAsReadUsecase _markMessagesAsReadUsecase;

  @override
  MessagingState build() {
    _createOrGetConversationUsecase = ref.read(
      createOrGetConversationUsecaseProvider,
    );
    _getAllConversationsUsecase = ref.read(getAllConversationsUsecaseProvider);
    _getConversationByIdUsecase = ref.read(getConversationByIdUsecaseProvider);
    _deleteConversationUsecase = ref.read(deleteConversationUsecaseProvider);
    _resetUnreadCountUsecase = ref.read(resetUnreadCountUsecaseProvider);
    _getConversationMessagesUsecase = ref.read(
      getConversationMessagesUsecaseProvider,
    );
    _sendMessageUsecase = ref.read(sendMessageUsecaseProvider);
    _deleteMessageUsecase = ref.read(deleteMessageUsecaseProvider);
    _markMessagesAsReadUsecase = ref.read(markMessagesAsReadUsecaseProvider);

    return MessagingState.initial();
  }

  // ============ Conversation Methods ============

  Future<bool> createOrGetConversation(String sellerId) async {
    state = state.copyWith(status: MessagingStatus.loading, clearError: true);

    final params = CreateOrGetConversationParams(sellerId: sellerId);
    final result = await _createOrGetConversationUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: MessagingStatus.error,
          error: failure.message,
        );
        return false;
      },
      (conversation) {
        state = state.copyWith(
          status: MessagingStatus.success,
          currentConversation: conversation,
          clearError: true,
        );
        return true;
      },
    );
  }

  Future<void> loadConversations() async {
    state = state.copyWith(status: MessagingStatus.loading, clearError: true);

    final result = await _getAllConversationsUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MessagingStatus.error,
          error: failure.message,
        );
      },
      (conversations) {
        state = state.copyWith(
          status: MessagingStatus.success,
          conversations: conversations,
          clearError: true,
        );
      },
    );
  }

  Future<bool> loadConversationById(String id) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final params = GetConversationByIdParams(id: id);
    final result = await _getConversationByIdUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (conversation) {
        state = state.copyWith(
          isActionLoading: false,
          currentConversation: conversation,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteConversation(String id) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final params = DeleteConversationParams(id: id);
    final result = await _deleteConversationUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (_) {
        final updatedList = state.conversations
            .where((conversation) => conversation.id != id)
            .toList();

        state = state.copyWith(
          isActionLoading: false,
          conversations: updatedList,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> resetUnreadCount(String id) async {
    final params = ResetUnreadCountParams(id: id);
    final result = await _resetUnreadCountUsecase(params);

    return result.fold((failure) => false, (_) {
      final updatedList = state.conversations.map((conversation) {
        if (conversation.id == id) {
          return ConversationEntity(
            id: conversation.id,
            userId: conversation.userId,
            sellerId: conversation.sellerId,
            unreadCount: 0,
            lastMessage: conversation.lastMessage,
            lastMessageAt: conversation.lastMessageAt,
            createdAt: conversation.createdAt,
            updatedAt: conversation.updatedAt,
            userInfo: conversation.userInfo,
            sellerInfo: conversation.sellerInfo,
          );
        }
        return conversation;
      }).toList();

      state = state.copyWith(conversations: updatedList);
      return true;
    });
  }

  // ============ Message Methods ============

  Future<void> loadMessages(String conversationId) async {
    state = state.copyWith(status: MessagingStatus.loading, clearError: true);

    final params = GetConversationMessagesParams(
      conversationId: conversationId,
    );
    final result = await _getConversationMessagesUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MessagingStatus.error,
          error: failure.message,
        );
      },
      (messages) {
        state = state.copyWith(
          status: MessagingStatus.success,
          messages: messages,
          clearError: true,
        );
        // Mark messages as read
        markMessagesAsRead(conversationId);
      },
    );
  }

  Future<bool> sendMessage(String conversationId, String content) async {
    if (content.trim().isEmpty) return false;

    state = state.copyWith(isSendingMessage: true, clearActionError: true);

    final params = SendMessageParams(
      conversationId: conversationId,
      content: content.trim(),
    );
    final result = await _sendMessageUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSendingMessage: false,
          actionError: failure.message,
        );
        return false;
      },
      (newMessage) {
        final updatedMessages = [...state.messages, newMessage];

        state = state.copyWith(
          isSendingMessage: false,
          messages: updatedMessages,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> deleteMessage(String id) async {
    state = state.copyWith(isActionLoading: true, clearActionError: true);

    final params = DeleteMessageParams(id: id);
    final result = await _deleteMessageUsecase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isActionLoading: false,
          actionError: failure.message,
        );
        return false;
      },
      (_) {
        final updatedMessages = state.messages
            .where((message) => message.id != id)
            .toList();

        state = state.copyWith(
          isActionLoading: false,
          messages: updatedMessages,
          clearActionError: true,
        );
        return true;
      },
    );
  }

  Future<bool> markMessagesAsRead(String conversationId) async {
    final params = MarkMessagesAsReadParams(conversationId: conversationId);
    final result = await _markMessagesAsReadUsecase(params);

    return result.fold((failure) => false, (_) {
      // Update messages to mark as read
      final updatedMessages = state.messages.map((message) {
        if (message.conversationId == conversationId) {
          return MessageEntity(
            id: message.id,
            conversationId: message.conversationId,
            senderId: message.senderId,
            content: message.content,
            isRead: true,
            createdAt: message.createdAt,
            senderInfo: message.senderInfo,
          );
        }
        return message;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
      return true;
    });
  }

  Future<void> refreshConversations() async {
    await loadConversations();
  }

  Future<void> refreshMessages(String conversationId) async {
    await loadMessages(conversationId);
  }

  void clearCurrentConversation() {
    state = state.copyWith(clearCurrentConversation: true, messages: []);
  }
}

import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';

enum MessagingStatus { initial, loading, success, error }

class MessagingState extends Equatable {
  final MessagingStatus status;
  final List<ConversationEntity> conversations;
  final List<MessageEntity> messages;
  final ConversationEntity? currentConversation;
  final String? error;
  final bool isActionLoading;
  final String? actionError;
  final bool isSendingMessage;

  const MessagingState({
    required this.status,
    required this.conversations,
    required this.messages,
    this.currentConversation,
    this.error,
    required this.isActionLoading,
    this.actionError,
    required this.isSendingMessage,
  });

  factory MessagingState.initial() {
    return const MessagingState(
      status: MessagingStatus.initial,
      conversations: [],
      messages: [],
      isActionLoading: false,
      isSendingMessage: false,
    );
  }

  MessagingState copyWith({
    MessagingStatus? status,
    List<ConversationEntity>? conversations,
    List<MessageEntity>? messages,
    ConversationEntity? currentConversation,
    String? error,
    bool? isActionLoading,
    String? actionError,
    bool? isSendingMessage,
    bool clearError = false,
    bool clearActionError = false,
    bool clearCurrentConversation = false,
  }) {
    return MessagingState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      currentConversation: clearCurrentConversation
          ? null
          : (currentConversation ?? this.currentConversation),
      error: clearError ? null : (error ?? this.error),
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    messages,
    currentConversation,
    error,
    isActionLoading,
    actionError,
    isSendingMessage,
  ];
}

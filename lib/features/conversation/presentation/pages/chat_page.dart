import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/features/conversation/presentation/state/messaging_state.dart';
import 'package:hamro_deal/features/conversation/presentation/view_model/messaging_view_model.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/chat_input.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(messagingViewModelProvider.notifier)
          .loadMessages(widget.conversationId);
    });
  }

  void _loadCurrentUserId() {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getCurrentUserId();
    setState(() {
      _currentUserId = userId;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref
        .read(messagingViewModelProvider.notifier)
        .refreshMessages(widget.conversationId);
  }

  Future<void> _handleSendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final success = await ref
        .read(messagingViewModelProvider.notifier)
        .sendMessage(widget.conversationId, content);

    if (success) {
      _messageController.clear();
      // Scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteMessageConfirmation(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(messagingViewModelProvider.notifier)
                  .deleteMessage(messageId);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagingState = ref.watch(messagingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList(messagingState)),
          ChatInput(
            controller: _messageController,
            onSend: _handleSendMessage,
            isSending: messagingState.isSendingMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(MessagingState state) {
    if (state.status == MessagingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == MessagingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'Failed to load messages',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          final isMe = message.senderId == _currentUserId;

          return MessageBubble(
            message: message,
            isMe: isMe,
            onLongPress: isMe
                ? () => _showDeleteMessageConfirmation(message.id)
                : null,
          );
        },
      ),
    );
  }
}

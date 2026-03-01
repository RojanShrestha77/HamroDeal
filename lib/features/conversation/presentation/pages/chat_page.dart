import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/features/conversation/presentation/state/messaging_state.dart';
import 'package:hamro_deal/features/conversation/presentation/view_model/messaging_view_model.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/chat_input.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherUserName;
  final String? otherUserProfileImage;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    this.otherUserProfileImage,
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
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }

  void _showDeleteMessageConfirmation(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Delete Message',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(messagingViewModelProvider.notifier)
                  .deleteMessage(messageId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message deleted'),
                    backgroundColor: Colors.black,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagingState = ref.watch(messagingViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        title: Row(
          children: [
            // Avatar circle with profile image or initial
            CircleAvatar(
              radius: 19,
              backgroundColor: const Color(0xFFEEEEEE),
              backgroundImage: widget.otherUserProfileImage != null
                  ? NetworkImage(ApiEndpoints.userProfileImage(widget.otherUserProfileImage!))
                  : null,
              child: widget.otherUserProfileImage == null
                  ? Text(
                      widget.otherUserName.isNotEmpty
                          ? widget.otherUserName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.otherUserName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: _handleRefresh,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, color: Colors.black, size: 20),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
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
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (state.status == MessagingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.error ?? 'Failed to load messages',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _handleRefresh,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 36,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
      color: Colors.black,
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

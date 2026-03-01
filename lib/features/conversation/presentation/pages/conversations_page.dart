import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/conversation/presentation/pages/chat_page.dart';
import 'package:hamro_deal/features/conversation/presentation/widgets/conversation_card.dart';
import 'package:hamro_deal/features/conversation/presentation/state/messaging_state.dart';
import 'package:hamro_deal/features/conversation/presentation/view_model/messaging_view_model.dart';

class ConversationsPage extends ConsumerStatefulWidget {
  const ConversationsPage({super.key});

  @override
  ConsumerState<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<ConversationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagingViewModelProvider.notifier).loadConversations();
    });
  }

  Future<void> _handleRefresh() async {
    await ref.read(messagingViewModelProvider.notifier).refreshConversations();
  }

  void _showDeleteConfirmation(String conversationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Delete Conversation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to delete this conversation? This will delete all messages.',
        ),
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
                  .deleteConversation(conversationId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Conversation deleted'),
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

  void _navigateToChat(String conversationId, String otherUserName, String? profileImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          conversationId: conversationId,
          otherUserName: otherUserName,
          otherUserProfileImage: profileImage,
        ),
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),
      body: _buildBody(messagingState),
    );
  }

  Widget _buildBody(MessagingState state) {
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
              state.error ?? 'Failed to load conversations',
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

    if (state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No conversations yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start chatting with sellers',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _handleRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: state.conversations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final conversation = state.conversations[index];
          final otherUser = conversation.sellerInfo ?? conversation.userInfo;
          return ConversationCard(
            conversation: conversation,
            onTap: () {
              final otherUserName =
                  conversation.sellerInfo?.username ??
                  conversation.userInfo?.username ??
                  'User';
              final profileImage = otherUser?.profileImage;
              _navigateToChat(conversation.id, otherUserName, profileImage);
            },
            onDelete: () => _showDeleteConfirmation(conversation.id),
          );
        },
      ),
    );
  }
}

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
        title: const Text('Delete Conversation'),
        content: const Text(
          'Are you sure you want to delete this conversation? This will delete all messages.',
        ),
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
                  .deleteConversation(conversationId);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conversation deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToChat(String conversationId, String otherUserName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          conversationId: conversationId,
          otherUserName: otherUserName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagingState = ref.watch(messagingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: _buildBody(messagingState),
    );
  }

  Widget _buildBody(MessagingState state) {
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
              state.error ?? 'Failed to load conversations',
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

    if (state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.conversations.length,
        itemBuilder: (context, index) {
          final conversation = state.conversations[index];
          return ConversationCard(
            conversation: conversation,
            onTap: () {
              // Determine other user name
              final otherUserName =
                  conversation.sellerInfo?.username ??
                  conversation.userInfo?.username ??
                  'User';

              _navigateToChat(conversation.id, otherUserName);
            },
            onDelete: () => _showDeleteConfirmation(conversation.id),
          );
        },
      ),
    );
  }
}

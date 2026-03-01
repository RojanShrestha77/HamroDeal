import 'package:flutter/material.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationCard extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final otherUser = conversation.sellerInfo ?? conversation.userInfo;
    final userName = otherUser?.username ?? otherUser?.email ?? 'User';
    final hasUnread = conversation.unreadCount > 0;

    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Conversation'),
            content: const Text(
              'Are you sure you want to delete this conversation?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: otherUser?.profileImage != null
                ? NetworkImage(ApiEndpoints.userProfileImage(otherUser!.profileImage!))
                : null,
            child: otherUser?.profileImage == null
                ? Text(
                    userName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (conversation.lastMessageAt != null)
                Text(
                  timeago.format(conversation.lastMessageAt!),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  conversation.lastMessage ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                    color: hasUnread ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ),
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${conversation.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

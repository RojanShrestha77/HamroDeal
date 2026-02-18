import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';

class AdminHeader extends ConsumerWidget {
  final VoidCallback onMenuToggle;
  final bool isSidebarExpanded;

  const AdminHeader({
    super.key,
    required this.onMenuToggle,
    required this.isSidebarExpanded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState
        .authEntity; // ← Changed from authState.user to authState.authEntity

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Menu toggle button
            Row(
              children: [
                IconButton(
                  icon: Icon(isSidebarExpanded ? Icons.menu_open : Icons.menu),
                  onPressed: onMenuToggle,
                  tooltip: isSidebarExpanded ? 'Collapse menu' : 'Expand menu',
                ),
                const SizedBox(width: 8),
                const Text(
                  'Admin Panel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // Right side - User info and logout
            Row(
              children: [
                // User info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user?.email ?? 'Admin',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user?.role?.toUpperCase() ?? 'ADMINISTRATOR',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // User avatar and logout menu
                PopupMenuButton<String>(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: user?.imageUrl != null
                        ? NetworkImage(user!.imageUrl!)
                        : null,
                    child: user?.imageUrl == null
                        ? Icon(Icons.person, size: 20, color: Colors.grey[700])
                        : null,
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog(context, ref);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? user?.username ?? 'Admin',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18),
                          SizedBox(width: 12),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear auth state (you may need to add a logout method to your view model)
              // ref.read(authViewModelProvider.notifier).logout();

              // Navigate to login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

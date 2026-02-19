import 'package:flutter/material.dart';
import 'package:hamro_deal/features/admin/orders/presentation/pages/admin_orders_screen.dart';
import 'package:hamro_deal/features/admin/users/presentation/pages/admin_users_screen.dart';

class AdminSidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const AdminSidebar({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 256 : 72,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          // Logo and toggle button
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.menu_open : Icons.menu,
                    size: 24,
                  ),
                  onPressed: onToggle,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 8),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  onTap: () {
                    // Stay on dashboard
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people,
                  label: 'Users',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminUsersScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.article,
                  label: 'Blogs',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Blogs page coming soon')),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag,
                  label: 'Orders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminOrdersScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Tooltip(
        message: isExpanded ? '' : label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: isExpanded
                  ? Row(
                      children: [
                        Icon(icon, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(icon, size: 24, color: Colors.grey[700]),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

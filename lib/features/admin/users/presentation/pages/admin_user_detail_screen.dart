import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/admin/users/presentation/view_model/admin_user_view_model.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  final AuthEntity user;

  const AdminUserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user profile
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.imageUrl != null
                        ? NetworkImage(
                            ApiEndpoints.userProfileImage(user.imageUrl!),
                          )
                        : null,
                    child: user.imageUrl == null
                        ? Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName.isEmpty ? user.username : user.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRoleChip(user.role ?? 'user'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // user info
            _buildSectionTitle('User Information'),
            _buildInfoCard([
              _buildInfoRow('Username', user.username),
              _buildInfoRow('Email', user.email),
              _buildInfoRow('First Name', user.firstName ?? 'N/A'),
              _buildInfoRow('Last Name', user.lastName ?? 'N/A'),
              _buildInfoRow('Role', user.role ?? 'user'),
            ]),

            // seller aAPPROVAL section
            if (user.role == 'seller') ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Seller Status'),
              _buildInfoCard([
                _buildInfoRow(
                  'Approval Status',
                  user.isApproved == true ? 'Approved' : 'Pending',
                ),
              ]),
              if (user.isApproved != true) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _approveSeller(context, ref),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Approve seller'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _approveSeller(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Seller'),
        content: Text(
          'Are you sure you want to approve ${user.username} as seller?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'admin':
        color = Colors.red;
        break;
      case 'seller':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete  ${user.username}? This action cannot be undone',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(adminUserViewModelProvider.notifier)
          .deleteUser(user.userId!);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deletde successfully')),
          );
          Navigator.pop(context);
        } else {
          final errorMessage = ref
              .read(adminUserViewModelProvider)
              .errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage ?? 'Failed to delete user')),
          );
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/admin/users/presentation/pages/admin_user_detail_screen.dart';
import 'package:hamro_deal/features/admin/users/presentation/state/admin_user_state.dart';
import 'package:hamro_deal/features/admin/users/presentation/view_model/admin_user_view_model.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUserViewModelProvider.notifier).getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUserViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users'), elevation: 0),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(AdminUserState state) {
    if (state.status == AdminUserViewStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == AdminUserViewStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? 'An error occured',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(adminUserViewModelProvider.notifier).getAllUsers();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
    if (state.users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(adminUserViewModelProvider.notifier).getAllUsers();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: user.imageUrl != null
                    ? NetworkImage(
                        ApiEndpoints.userProfileImage(user.imageUrl!),
                      )
                    : null,
                child: user.imageUrl == null
                    ? Text(user.username[0].toUpperCase())
                    : null,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      user.fullName.isEmpty ? user.username : user.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildRoleChip(user.role ?? 'user'),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email),
                  if (user.role == 'seller')
                    _buildApprovalStatus(user.isApproved ?? false),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUserDetailScreen(user: user),
                  ),
                );
              },
            ),
          );
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(bool isApproved) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isApproved ? 'Approved' : 'Pending Approval',
        style: TextStyle(
          color: isApproved ? Colors.green : Colors.orange,
          fontSize: 11,
        ),
      ),
    );
  }
}

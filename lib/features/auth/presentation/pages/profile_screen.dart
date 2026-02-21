import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_view_model.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/admin/pages/admin_dashboard_screen.dart';
import 'package:hamro_deal/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hamro_deal/features/category/presentation/pages/add_category_screen.dart';
import 'package:hamro_deal/features/order/presentation/pages/order_list_screen.dart';
import 'package:hamro_deal/features/cart/presentation/pages/cart_screen.dart';
import 'package:hamro_deal/features/home/presentation/pages/home_screen.dart';
import 'package:hamro_deal/features/order/presentation/pages/order_screen.dart';
import 'package:hamro_deal/features/auth/presentation/pages/login_screen.dart';
import 'package:hamro_deal/features/product/presentation/page/porduct_browse_screen.dart';
import 'package:hamro_deal/features/seller/presentation/pages/seller_dashboard_screen.dart';
import 'package:hamro_deal/features/wishlist/presentation/page/wishlist_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),

            _buildProfileHeader(context, user),

            const SizedBox(height: 16),

            const Text("Hi,", textAlign: TextAlign.center),
            Text(
              user?.fullName ?? "Guest User",
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Jost Bold', fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Menu Items
            // _buildMenuItem(context, "My orders", const OrderScreen()),
            // Add this with other menu items
            _buildThemeToggle(context, ref),
            _buildThemeModeSelector(context, ref),

            _buildMenuItem(context, "Home", HomeScreen()),
            _buildMenuItem(context, "Sign out", LoginPage()),
            _buildMenuItem(context, "Cart", const CartScreen()),
            _buildMenuItem(context, "Product", const PorductBrowseScreen()),
            _buildMenuItem(context, "Edit Profile", const EditProfilePage()),
            _buildMenuItem(context, "Add Category", const AddCategoryScreen()),
            _buildMenuItem(context, "Wishlist", const WishlistScreen()),
            _buildMenuItem(context, "Order List", const OrderListScreen()),
            if (user?.role?.toLowerCase() == 'admin')
              _buildMenuItem(context, "Admin", const AdminDashboardScreen()),
            if (user?.role?.toLowerCase() == 'seller')
              _buildMenuItem(context, "Seller", const SellerDashboardScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);
    final isDark = themeState.themeMode == ThemeMode.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dark Mode'),
              Switch(
                value: isDark,
                onChanged: (value) {
                  ref.read(themeViewModelProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
        ),
        const Divider(thickness: 2, indent: 32, endIndent: 32),
      ],
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theme Mode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Light Mode
              RadioListTile<String>(
                title: const Text('Light'),
                value: 'light',
                groupValue: themeState.isAutoMode
                    ? 'auto'
                    : (themeState.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark'),
                onChanged: (value) {
                  ref.read(themeViewModelProvider.notifier).setLightMode();
                },
                contentPadding: EdgeInsets.zero,
              ),

              // Dark Mode
              RadioListTile<String>(
                title: const Text('Dark'),
                value: 'dark',
                groupValue: themeState.isAutoMode
                    ? 'auto'
                    : (themeState.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark'),
                onChanged: (value) {
                  ref.read(themeViewModelProvider.notifier).setDarkMode();
                },
                contentPadding: EdgeInsets.zero,
              ),

              // Auto Mode
              RadioListTile<String>(
                title: const Text('Auto (Light Sensor)'),
                subtitle: !themeState.hasLightSensor && themeState.isAutoMode
                    ? const Text(
                        'Light sensor not available on this device',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : null,
                value: 'auto',
                groupValue: themeState.isAutoMode
                    ? 'auto'
                    : (themeState.themeMode == ThemeMode.light
                          ? 'light'
                          : 'dark'),
                onChanged: (value) async {
                  await ref
                      .read(themeViewModelProvider.notifier)
                      .enableAutoMode();

                  // Show error if sensor not available
                  if (!ref.read(themeViewModelProvider).hasLightSensor) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Auto mode not supported on this device',
                          ),
                        ),
                      );
                    }
                  }
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Divider(thickness: 2, indent: 32, endIndent: 32),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Divider(thickness: 2, color: Colors.black),

          // Profile Picture CircleAvatar
          CircleAvatar(
            radius: 55,
            backgroundColor: const Color.fromARGB(255, 40, 39, 39),
            backgroundImage: _getProfileImage(user),
            onBackgroundImageError: _getProfileImage(user) != null
                ? (exception, stackTrace) {
                    debugPrint('Error loading profile image: $exception');
                  }
                : null,
            child: _getProfileImage(user) == null
                ? _getInitials(user?.fullName ?? "Guest")
                : null,
          ),

          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width / 2 - 75,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage(dynamic user) {
    if (user?.imageUrl != null && user!.imageUrl!.isNotEmpty) {
      final imageUrl = user.imageUrl!;

      return NetworkImage(ApiEndpoints.userProfileImage(imageUrl));
    }
    return null;
  }

  Widget _getInitials(String name) {
    final trimmedName = name.trim();

    // Handle empty name
    if (trimmedName.isEmpty) {
      return const Text(
        '?',
        style: TextStyle(color: Colors.white, fontSize: 30),
      );
    }

    final nameParts = trimmedName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    String initials;
    if (nameParts.isEmpty) {
      initials = '?';
    } else if (nameParts.length >= 2) {
      initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      initials = nameParts[0][0].toUpperCase();
    }

    return Text(
      initials,
      style: const TextStyle(color: Colors.white, fontSize: 30),
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title, Widget destination) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              const Icon(Icons.chevron_right, color: Colors.black, size: 28),
            ],
          ),
        ),
      ),
      const Divider(thickness: 2, indent: 32, endIndent: 32),
    ],
  );
}

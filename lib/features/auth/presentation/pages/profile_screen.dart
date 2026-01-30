import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hamro_deal/features/category/presentation/pages/add_category_screen.dart';
import 'package:hamro_deal/features/product/presentation/page/add_product_screen.dart';
import 'package:hamro_deal/features/product/presentation/page/my_products_page.dart';
import 'package:hamro_deal/screens/bottom_screen/cart_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/home_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/order_screen.dart';
import 'package:hamro_deal/features/auth/presentation/pages/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get auth state
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),

            // ✨ PROFILE HEADER SECTION
            _buildProfileHeader(context, user),

            const SizedBox(height: 16),

            // ✨ USER NAME (Dynamic)
            const Text("Hi,", textAlign: TextAlign.center),
            Text(
              user?.fullName ?? "Guest User", // ← Dynamic name
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Jost Bold', fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Menu Items
            _buildMenuItem(context, "My orders", const OrderScreen()),
            _buildMenuItem(context, "Home", HomeScreen()),
            _buildMenuItem(context, "Sign out", LoginPage()),
            _buildMenuItem(context, "Cart", const CartScreen()),
            _buildMenuItem(context, "Add Products", const AddProductScreen()),
            _buildMenuItem(context, "Edit Profile", const EditProfilePage()),
            _buildMenuItem(context, "Add Category", const AddCategoryScreen()),
            _buildMenuItem(context, "My Products", const MyProductsPage()),
            _buildMenuItem(context, "Wishlist", const CartScreen()),
          ],
        ),
      ),
    );
  }

  // ✨ PROFILE HEADER WITH PICTURE
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
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading profile image: $exception');
            },
            child: _getProfileImage(user) == null
                ? _getInitials(user?.fullName ?? "Guest")
                : null,
          ),

          // ✨ Edit button overlay
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

  // ✨ GET PROFILE IMAGE
  ImageProvider? _getProfileImage(dynamic user) {
    if (user?.profileImage != null && user!.profileImage!.isNotEmpty) {
      final imageUrl = user.profileImage!;

      // If already full URL, use as is
      if (imageUrl.startsWith('http')) {
        return NetworkImage(imageUrl);
      }

      // Otherwise, construct full URL
      return NetworkImage('${ApiEndpoints.mediaServerUrl}/$imageUrl');
    }
    return null;
  }

  // ✨ GET USER INITIALS FOR AVATAR
  Widget _getInitials(String name) {
    final nameParts = name.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');

    return Text(
      initials,
      style: const TextStyle(color: Colors.white, fontSize: 30),
    );
  }
}

// ✨ MENU ITEM BUILDER
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

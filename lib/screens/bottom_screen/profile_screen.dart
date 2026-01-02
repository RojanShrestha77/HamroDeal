import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/bottom_screen/cart_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/home_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/order_screen.dart';
import 'package:hamro_deal/features/auth/presentation/pages/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Account")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),

            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Divider(thickness: 2, color: Colors.black),

                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color.fromARGB(255, 40, 39, 39),
                    child: Text(
                      "RS",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text("Hi,", textAlign: TextAlign.center),
            const Text(
              "Rojan Shrestha,",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Jost Bold', fontSize: 16),
            ),

            const SizedBox(height: 24),

            _buildMenuItem(context, "My orders", const OrderScreen()),
            _buildMenuItem(context, "home out", HomeScreen()),
            _buildMenuItem(context, "Sign out", LoginScreen()),
            _buildMenuItem(context, "Profile", ProfileScreen()),
            _buildMenuItem(context, "Cart", CartScreen()),
            _buildMenuItem(context, "Cart", CartScreen()),
            _buildMenuItem(context, "Cart", CartScreen()),
            _buildMenuItem(context, "Cart", CartScreen()),
            _buildMenuItem(context, "Cart", CartScreen()),
            _buildMenuItem(context, "Wishlist", CartScreen()),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title, Widget destination) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: InkWell(
          // makes it tapable
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
      Divider(thickness: 2, indent: 32, endIndent: 32),
    ],
  );
}

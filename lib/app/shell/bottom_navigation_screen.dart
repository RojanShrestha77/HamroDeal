import 'package:flutter/material.dart';
import 'package:hamro_deal/features/cart/presentation/pages/cart_screen.dart';
import 'package:hamro_deal/features/home/presentation/pages/home_screen.dart';
import 'package:hamro_deal/features/conversation/presentation/pages/conversations_page.dart';
import 'package:hamro_deal/features/auth/presentation/pages/profile_screen.dart';
import 'package:hamro_deal/features/product/presentation/page/porduct_browse_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomScreens = [
    HomeScreen(), // index 0
    const CartScreen(), // index 1
    const PorductBrowseScreen(), // index 2
    const ConversationsPage(), // index 3
    const ProfileScreen(), // index 4
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onTabSelected(0),
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onTabSelected(1),
                ),
                _buildNavItem(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onTabSelected(2),
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  selectedIcon: Icons.chat_bubble,
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onTabSelected(3),
                ),
                _buildNavItem(
                  icon: Icons.person_outlined,
                  selectedIcon: Icons.person,
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onTabSelected(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? selectedIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          // Added Center widget
          child: Icon(
            isSelected ? (selectedIcon ?? icon) : icon,
            color: isSelected ? Colors.white : Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}

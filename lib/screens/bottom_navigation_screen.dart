import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/bottom_screen/cart_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/search_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/home_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  // Only three screens now: Home, Cart, Profile
  final List<Widget> bottomScreens = [
    HomeScreen(), // index 0
    const SearchScreen(),
    const CartScreen(), // index 1
    const ProfileScreen(), // index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF147AFF),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

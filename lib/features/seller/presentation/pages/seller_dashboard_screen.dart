import 'package:flutter/material.dart';
import 'package:hamro_deal/features/seller/presentation/pages/seller_sidebar.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  bool _isSidebarExpanded = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSidebarExpanded ? 256 : 72,
              child: SellerSidebar(
                isExpanded: _isSidebarExpanded,
                onToggle: _toggleSidebar,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store, size: 100, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Seller Dashboard',
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

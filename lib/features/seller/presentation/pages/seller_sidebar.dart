import 'package:flutter/material.dart';
import 'package:hamro_deal/features/product/presentation/page/my_products_page.dart';
import 'package:hamro_deal/features/product/presentation/page/add_product_screen.dart';

class SellerSidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const SellerSidebar({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          // Header
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
                  tooltip: isExpanded ? 'Collapse' : 'Expand',
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 8),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
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
                      'Seller Panel',
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
          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  onTap: () {
                    // Navigate to dashboard (current screen)
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.inventory,
                  label: 'My Products',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProductsPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.add_box,
                  label: 'Add Product',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag,
                  label: 'Orders',
                  onTap: () {
                    // TODO: Navigate to seller orders
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

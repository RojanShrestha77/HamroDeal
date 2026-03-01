import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/cart/presentation/state/cart_state.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/order/presentation/pages/checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartViewModelProvider.notifier).getCart());
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cartViewModel = ref.read(cartViewModelProvider.notifier);

    ref.listen<CartState>(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.black,
          ),
        );
      }
      if (next.status == CartStatus.itemAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added to cart'),
            backgroundColor: Colors.black,
          ),
        );
      }
      if (next.status == CartStatus.cartCleared) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart cleared'),
            backgroundColor: Colors.black,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          if (cartState.cart != null && !cartState.cart!.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black),
              onPressed: () => _showClearCartDialog(context, cartViewModel),
            ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),
      body: cartState.status == CartStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : cartState.cart == null || cartState.cart!.isEmpty
          ? _buildEmptyCart()
          : _buildCartList(cartState, cartViewModel),
      bottomNavigationBar: cartState.cart != null && !cartState.cart!.isEmpty
          ? _buildCheckoutBar(cartState)
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Start Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(CartState cartState, CartViewModel cartViewModel) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cartState.cart!.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = cartState.cart!.items[index];
        final product = item.product;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: product?.images != null
                      ? Image.network(
                          ApiEndpoints.productImage(product!.images!),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.title ?? 'Product',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rs. ${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quantity Controls
                    Row(
                      children: [
                        _buildQtyButton(
                          icon: Icons.remove,
                          onTap: item.quantity > 1
                              ? () => cartViewModel.updateCartItem(
                                  item.productId,
                                  item.quantity - 1,
                                )
                              : null,
                        ),
                        Container(
                          width: 36,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(color: Color(0xFFEEEEEE)),
                            ),
                          ),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _buildQtyButton(
                          icon: Icons.add,
                          onTap: () => cartViewModel.updateCartItem(
                            item.productId,
                            item.quantity + 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remove Button
              GestureDetector(
                onTap: () => _showRemoveDialog(
                  context,
                  cartViewModel,
                  item.productId,
                  product?.title ?? 'this item',
                ),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQtyButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.black : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(CartState cartState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order summary rows
            _buildSummaryRow(
              'Subtotal (${cartState.cart!.itemCount} items)',
              'Rs. ${cartState.cart!.total.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 6),
            _buildSummaryRow('Shipping', 'Free'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: Color(0xFFEEEEEE)),
            ),
            _buildSummaryRow(
              'Total',
              'Rs. ${cartState.cart!.total.toStringAsFixed(0)}',
              bold: true,
            ),
            const SizedBox(height: 14),

            // Checkout button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: bold ? Colors.black : Colors.grey[600],
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    CartViewModel cartViewModel,
    String productId,
    String productName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Remove Item',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          'Remove $productName from cart?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              cartViewModel.removeFromCart(productId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartViewModel cartViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Clear Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              cartViewModel.clearCart();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

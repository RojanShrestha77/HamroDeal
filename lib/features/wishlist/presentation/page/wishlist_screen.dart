import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:hamro_deal/features/wishlist/presentation/view_model/wishlist_view_model.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(wishlistViewModelProvider.notifier).getWishlist(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);
    final cartViewModel = ref.read(cartViewModelProvider.notifier);

    // Show snackbar messages
    ref.listen<WishlistState>(wishlistViewModelProvider, (previous, next) {
      if (next.status == WishlistStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.status == WishlistStatus.itemAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to wishlist'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (next.status == WishlistStatus.wishlistCleared) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wishlist cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          if (wishlistState.wishlist != null &&
              !wishlistState.wishlist!.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  _showClearWishlistDialog(context, wishlistViewModel),
            ),
        ],
      ),
      body: wishlistState.status == WishlistStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : wishlistState.wishlist == null || wishlistState.wishlist!.isEmpty
          ? _buildEmptyWishlist()
          : _buildWishlistGrid(wishlistState, wishlistViewModel, cartViewModel),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(
    WishlistState wishlistState,
    WishlistViewModel wishlistViewModel,
    CartViewModel cartViewModel,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: wishlistState.wishlist!.items.length,
      itemBuilder: (context, index) {
        final item = wishlistState.wishlist!.items[index];
        final product = item.product;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                child: Stack(
                  children: [
                    product?.images != null
                        ? Image.network(
                            ApiEndpoints.productImage(product!.images!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                    // Remove button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () {
                            wishlistViewModel.removeFromWishlist(
                              item.productId,
                            );
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Product Info
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.title ?? 'Product',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${product?.price.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: product != null && product.stock > 0
                            ? () async {
                                final success = await cartViewModel.addToCart(
                                  product.productId!,
                                  1,
                                );
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearWishlistDialog(
    BuildContext context,
    WishlistViewModel wishlistViewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Remove all items from wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              wishlistViewModel.clearWishlist();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

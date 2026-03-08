import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/utils/responsive_utils.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/wishlist/presentation/view_model/wishlist_view_model.dart';

class VerticalProductCard extends ConsumerWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const VerticalProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the STATE (not just the notifier) so UI rebuilds when wishlist changes
    ref.watch(wishlistViewModelProvider);
    final wishlistNotifier = ref.read(wishlistViewModelProvider.notifier);
    final isInWishlist = wishlistNotifier.isInWishlist(product.productId!);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image (flex 3 — balanced for smaller screens) ──
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: product.images != null && product.images!.isNotEmpty
                        ? Image.network(
                            ApiEndpoints.productImage(product.images!.first),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: const Color(0xFFF5F5F5),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF5F5F5),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFFF5F5F5),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  // ✅ Heart icon — color now reactive to wishlist state
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        if (isInWishlist) {
                          await wishlistNotifier.removeFromWishlist(
                            product.productId!,
                          );
                        } else {
                          await wishlistNotifier.addToWishlist(
                            product.productId!,
                          );
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isInWishlist),
                          color: isInWishlist ? Colors.red : Colors.black,
                          size: ResponsiveUtils.getIconSize(context, mobileSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info (flex 2) ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8), // Reduced top padding from 12 to 8
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 14, // Reduced further from 15 to 14
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Rs. ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const Spacer(),

                    // Add to cart button
                    GestureDetector(
                      onTap: product.stock > 0
                          ? () async {
                              final success = await ref
                                  .read(cartViewModelProvider.notifier)
                                  .addToCart(product.productId!, 1);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Added to cart'
                                          : 'Failed to add to cart',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? const Color(0xFF1C1C1C)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          product.stock > 0 ? 'Add to cart' : 'Out of stock',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: product.stock > 0
                                ? Colors.white
                                : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/core/utils/responsive_utils.dart';
import 'package:hamro_deal/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/conversation/presentation/pages/chat_page.dart';
import 'package:hamro_deal/features/conversation/presentation/view_model/messaging_view_model.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_deal/features/review/presentation/widgets/product_reviews_section.dart';
import 'package:hamro_deal/features/wishlist/presentation/view_model/wishlist_view_model.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.microtask(
      () => ref.read(wishlistViewModelProvider.notifier).getWishlist(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Other';
    final categoryState = ref.read(categoryViewModelProvider);
    final category = categoryState.categories.where(
      (c) => c.categoryId == categoryId,
    );
    return category.isNotEmpty ? category.first.name : 'Other';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: const Text(
          'Delete Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.product.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(dialogContext);
              if (widget.product.productId != null) {
                ref
                    .read(productViewModelProvider.notifier)
                    .deleteProduct(widget.product.productId!);
                Navigator.pop(context);
                SnackbarUtils.showSuccess(
                  context,
                  'Product deleted successfully',
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Delete',
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

  @override
  Widget build(BuildContext context) {
    final categoryName = _getCategoryName(widget.product.categoryId);
    final cartViewModel = ref.read(cartViewModelProvider.notifier);

    // Watch state for reactivity
    ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);
    final isInWishlist = wishlistViewModel.isInWishlist(
      widget.product.productId ?? '',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        actions: [
          // Wishlist heart
          GestureDetector(
            onTap: () async {
              if (isInWishlist) {
                final success = await wishlistViewModel.removeFromWishlist(
                  widget.product.productId!,
                );
                if (success && mounted) {
                  SnackbarUtils.showSuccess(context, 'Removed from wishlist');
                }
              } else {
                final success = await wishlistViewModel.addToWishlist(
                  widget.product.productId!,
                );
                if (success && mounted) {
                  SnackbarUtils.showSuccess(context, 'Added to wishlist');
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isInWishlist),
                  color: isInWishlist ? Colors.red : Colors.black,
                  size: ResponsiveUtils.getIconSize(context, mobileSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image Carousel ──
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ResponsiveUtils.getProductImageMaxHeight(context),
              ),
              child: AspectRatio(
                aspectRatio: ResponsiveUtils.getProductImageAspectRatio(context),
                child: Container(
                  color: const Color(0xFFF5F5F5),
                  child: widget.product.images != null && widget.product.images!.isNotEmpty
                    ? Stack(
                        children: [
                          // Image PageView
                          PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemCount: widget.product.images!.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                ApiEndpoints.productImage(widget.product.images![index]),
                                width: double.infinity,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 1.5,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          
                          // Navigation arrows (only show if multiple images)
                          if (widget.product.images!.length > 1) ...[
                            // Left arrow
                            if (_currentImageIndex > 0)
                              Positioned(
                                left: 16,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      width: ResponsiveUtils.getIconSize(context, mobileSize: 40),
                                      height: ResponsiveUtils.getIconSize(context, mobileSize: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: Colors.black,
                                        size: ResponsiveUtils.getIconSize(context, mobileSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Right arrow
                            if (_currentImageIndex < widget.product.images!.length - 1)
                              Positioned(
                                right: 16,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      width: ResponsiveUtils.getIconSize(context, mobileSize: 40),
                                      height: ResponsiveUtils.getIconSize(context, mobileSize: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                        size: ResponsiveUtils.getIconSize(context, mobileSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Dot indicators
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.product.images!.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: _currentImageIndex == index ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _currentImageIndex == index
                                          ? Colors.black
                                          : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : const Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            ),

            // ── Product Info ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + category badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontSize: 18, // Reduced from 20
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Price + Stock row ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs. ${widget.product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Availability',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.product.stock > 0
                                    ? Colors.black
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                widget.product.stock > 0
                                    ? '${widget.product.stock} in stock'
                                    : 'Out of stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: widget.product.stock > 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFEEEEEE)),

            // ── Reviews ──
            ProductReviewsSection(productId: widget.product.productId!),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ── Bottom Action Bar ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Message Seller button
              if (widget.product.sellerId != null) ...[
                GestureDetector(
                  onTap: () async {
                    if (widget.product.sellerId == null) {
                      SnackbarUtils.showError(
                        context,
                        'Seller information not available',
                      );
                      return;
                    }
                    final conversationViewModel = ref.read(
                      messagingViewModelProvider.notifier,
                    );
                    final success = await conversationViewModel
                        .createOrGetConversation(widget.product.sellerId!);

                    if (success && mounted) {
                      final state = ref.read(messagingViewModelProvider);
                      final conversation = state.currentConversation;
                      if (conversation != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              conversationId: conversation.id,
                              otherUserName:
                                  conversation.sellerInfo?.username ??
                                  conversation.userInfo?.username ??
                                  'Seller',
                            ),
                          ),
                        );
                      } else {
                        SnackbarUtils.showError(
                          context,
                          'Conversation data not available',
                        );
                      }
                    } else if (mounted) {
                      final state = ref.read(messagingViewModelProvider);
                      SnackbarUtils.showError(
                        context,
                        state.error ?? 'Failed to open conversation',
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          color: Colors.black,
                          size: ResponsiveUtils.getIconSize(context, mobileSize: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Message Seller',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Quantity + Add to Cart
              Row(
                children: [
                  // Quantity selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      children: [
                        _buildQtyButton(
                          icon: Icons.remove,
                          onTap: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _buildQtyButton(
                          icon: Icons.add,
                          onTap: _quantity < widget.product.stock
                              ? () => setState(() => _quantity++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to Cart button
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.product.stock > 0
                          ? () async {
                              final success = await cartViewModel.addToCart(
                                widget.product.productId!,
                                _quantity,
                              );
                              if (success && mounted) {
                                SnackbarUtils.showSuccess(
                                  context,
                                  'Added to cart successfully',
                                );
                              } else if (mounted) {
                                SnackbarUtils.showError(
                                  context,
                                  'Failed to add to cart',
                                );
                              }
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: widget.product.stock > 0
                              ? Color(0xFF1C1C1C)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: widget.product.stock > 0
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: ResponsiveUtils.getIconSize(context, mobileSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.product.stock > 0
                                  ? 'Add to Cart'
                                  : 'Out of Stock',
                              style: TextStyle(
                                color: widget.product.stock > 0
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 46,
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
}

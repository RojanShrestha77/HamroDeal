import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/user_session_service.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/core/utils/responsive_utils.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/page/edit_product_page.dart';
import 'package:hamro_deal/features/product/presentation/page/product_detail_page.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';

class MyProductsPage extends ConsumerStatefulWidget {
  const MyProductsPage({super.key});

  @override
  ConsumerState<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends ConsumerState<MyProductsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  void _loadData() {
    print(' 🔵 [MyProducts] _loadData called');
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getCurrentUserId();
    print('🔵 [MyProducts] UserID: $userId');
    if (userId != null) {
      print('🔵 [MyProducts] caaling getMyProducts with userId: $userId');
      ref.read(productViewModelProvider.notifier).getMyProducts(userId);
    } else {
      print('🔵 [Myproducts] user id iss null');
    }
    ref.read(categoryViewModelProvider.notifier).getAllCategories();
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Other';
    final categoryState = ref.read(categoryViewModelProvider);
    final category = categoryState.categories.where(
      (c) => c.categoryId == categoryId,
    );
    return category.isNotEmpty ? category.first.name : 'Other';
  }

  @override // ✅ Added this
  Widget build(BuildContext context) {
    final productState = ref.watch(productViewModelProvider);
    final myProducts = productState.myProducts;

    // Listen for delete success
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.deleted) {
        SnackbarUtils.showSuccess(context, 'Product deleted successfully');
        _loadData(); // Reload products
      } else if (next.status == ProductStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, myProducts.length),
            const SizedBox(height: 20),
            Expanded(
              child: productState.status == ProductStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductList(myProducts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int productCount) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Products',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$productCount ${productCount == 1 ? 'product' : 'products'} listed',
                  style: TextStyle(fontSize: 14, color: context.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<ProductEntity> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: context.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No products listed yet',
              style: TextStyle(
                fontSize: 16,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start selling by adding your first product',
              style: TextStyle(fontSize: 14, color: context.textTertiary),
            ),
          ],
        ),
      );
    }

    print('TotAL PRODUCTS: ${products.length}');
    for (var product in products) {
      print('Product ${product.title}');
      print('Images Url: ${product.images}');
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    if (isTablet) {
      // Tablet: Use GridView
      final columns = ResponsiveUtils.getGridColumns(context);
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final categoryName = _getCategoryName(product.categoryId);

          return _ProductCard(
            product: product,
            categoryName: categoryName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: product),
                ),
              );
            },
            onDelete: () => _showDeleteDialog(context, product),
            isTablet: true,
          );
        },
      );
    } else {
      // Mobile: Use ListView
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final categoryName = _getCategoryName(product.categoryId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ProductCard(
              product: product,
              categoryName: categoryName,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductPage(product: product),
                  ),
                );
              },
              onDelete: () => _showDeleteDialog(context, product),
            ),
          );
        },
      );
    }
  }

  void _showDeleteDialog(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (product.productId != null) {
                ref
                    .read(productViewModelProvider.notifier)
                    .deleteProduct(product.productId!);
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  final String categoryName;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isTablet;

  const _ProductCard({
    required this.product,
    required this.categoryName,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = isTablet ? 140.0 : 180.0;

    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: context.softShadow,
        ),
        child: Column(
          children: [
            // Product Image
            if (product.images != null && product.images!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  ApiEndpoints.productImage(product.images!.first),
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('🔴 Image error: $error');
                    print(
                      '🔴 Tried URl: ${ApiEndpoints.productImage(product.images!.first)}',
                    );
                    return Container(
                      height: imageHeight,
                      color: context.borderColor,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: context.textTertiary,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: context.textTertiary,
                  ),
                ),
              ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(isTablet ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 8 : 12,
                          vertical: isTablet ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: isTablet ? 10 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 14,
                      color: context.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isTablet ? 8 : 12),

                  // Price/Stock Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: isTablet ? 10 : 12,
                              color: context.textTertiary,
                            ),
                          ),
                          Text(
                            'Rs. ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 20,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Stock',
                            style: TextStyle(
                              fontSize: isTablet ? 10 : 12,
                              color: context.textTertiary,
                            ),
                          ),
                          Text(
                            '${product.stock} units',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 16,
                              fontWeight: FontWeight.w600,
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 10 : 16),
                  if (!isTablet)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text('Edit', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Delete', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
    );

    // Add padding only for tablet grid view
    if (isTablet) {
      return card;
    }
    return card;
  }
}

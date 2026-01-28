import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final ProductEntity product;
  // final String categoryName;

  const ProductDetailPage({
    super.key,
    required this.product,
    // required this.categoryName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Other';
    final categoryState = ref.read(categoryViewModelProvider);
    final category = categoryState.categories.where(
      (c) => c.categoryId == categoryId,
    );
    return category.isNotEmpty ? category.first.name : 'Other';
  }

  // show delte confirmation dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.product.productName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (widget.product.productId != null) {
                ref
                    .read(productViewModelProvider.notifier)
                    .deleteProduct(widget.product.productId!);

                Navigator.pop(context);
                SnackbarUtils.showSuccess(
                  context,
                  'Product deleted successfullly',
                );
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

  @override
  Widget build(BuildContext context) {
    final categoryName = _getCategoryName(widget.product.category);
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.productName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // product imageCache
            if (widget.product.media != null)
              AspectRatio(
                aspectRatio: 1.0,

                child: Image.network(
                  ApiEndpoints.itemPicture(widget.product.media!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, StackTrace) {
                    return Container(
                      color: context.borderColor,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color: context.textTertiary,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  color: context.borderColor,
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: context.textTertiary,
                    ),
                  ),
                ),
              ),
            // adding product info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.productName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // product description
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // prize/stock row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textTertiary,
                            ),
                          ),
                          Text(
                            'Rs.${widget.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
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
                              fontSize: 12,
                              color: context.textTertiary,
                            ),
                          ),
                          Text(
                            '${widget.product.quantity} units',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: widget.product.quantity > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         // what goes here
            //         style: TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: context.textPrimary,
            //         )
            //       )
            //     ),
            //     // todo: add category badge
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
